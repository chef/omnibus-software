#!/usr/bin/env ruby

require "open3"

# Get the branch to compare against (rename default to 'main' once migration occurs)
BRANCH = ENV["BUILDKITE_PULL_REQUEST_BASE_BRANCH"] || "main"

# Read in all the versions that are specified by SOFTWARE
def version(version = nil)
  $versions << version
end

def default_version(version = nil)
  $versions << version
end

# Get a list of all the config/software definitions that have been added or modified
_, status = Open3.capture2e("git config --global --add safe.directory /workdir")
exit 1 if status != 0
_, status = Open3.capture2e("git fetch origin #{BRANCH}")
exit 1 if status != 0
stdout, status = Open3.capture2("git diff --name-status origin/#{BRANCH}...HEAD config/software | awk 'match($1, \"A\"){print $2; next} match($1, \"M\"){print $2}'")
exit 1 if status != 0

files = stdout.lines.compact.uniq.map(&:chomp)
exit 0 if files.empty?

puts "steps:"
files.each do |file|
  software = File.basename(file, ".rb")
  $versions = []

  File.readlines(file).each do |line|
    # match if line starts with "default_version" or "version"
    if line.match(/^\s*(default_)?version/)
      # remove the beginning of any ruby block if it exists
      line.sub!(/\s*(do|{).*/, "")

      # rubocop:disable Security/Eval
      eval(line)
    end
  end

  # Skip health check when it is not relevant
  health_check_skip_list = %w{ cacerts xproto util-macros }
  deprecated_skip_list = %w{ git-windows cmake ruby-msys2-devkit }

  $versions.compact.uniq.each do |version|
    next if deprecated_skip_list.include?(software)

    skip_health_check = ""
    if health_check_skip_list.include?(software)
      skip_health_check = "-e SKIP_HEALTH_CHECK=1"
    end
    puts <<~EOH
      - label: "test-build (#{software} #{version})"
        key: "test-build-#{software.gsub(/[^a-zA-Z0-9_-]/, "-")}-#{version.gsub(/[^a-zA-Z0-9_-]/, "-")}"
        command: docker-compose run --rm -e SOFTWARE=#{software} -e VERSION=#{version} #{skip_health_check} -e CI builder
        timeout_in_minutes: 30
        expeditor:
          executor:
            linux:
              privileged: true
    EOH

    # Add OpenSSL validation steps
    if software == "openssl" && Gem::Version.new(version) >= Gem::Version.new("3.0.9")
      puts <<~EOH
        - label: "validate-openssl-executable (#{software} #{version})"
          key: "validate-openssl-executable-#{software.gsub(/[^a-zA-Z0-9_-]/, "-")}-#{version.gsub(/[^a-zA-Z0-9_-]/, "-")}"
          command: docker-compose run --rm -e SOFTWARE=#{software} -e VERSION=#{version} -e CI builder /omnibus-software/test/validation/build_and_validate_openssl_executable.sh
          timeout_in_minutes: 40
          expeditor:
            executor:
              linux:
                privileged: true

        - label: "validate-openssl-ruby-integration (#{software} #{version})"
          key: "validate-openssl-ruby-integration-#{software.gsub(/[^a-zA-Z0-9_-]/, "-")}-#{version.gsub(/[^a-zA-Z0-9_-]/, "-")}"
          command: docker-compose run --rm -e SOFTWARE=#{software} -e VERSION=#{version} -e CI builder /omnibus-software/test/validation/build_and_validate_openssl_ruby.sh
          timeout_in_minutes: 40
          expeditor:
            executor:
              linux:
                privileged: true

        - label: "validate-openssl-providers-config (#{software} #{version})"
          key: "validate-openssl-providers-config-#{software.gsub(/[^a-zA-Z0-9_-]/, "-")}-#{version.gsub(/[^a-zA-Z0-9_-]/, "-")}"
          command: docker-compose run --rm -e SOFTWARE=#{software} -e VERSION=#{version} -e CI builder /omnibus-software/test/validation/build_and_validate_openssl_providers.sh
          timeout_in_minutes: 40
          expeditor:
            executor:
              linux:
                privileged: true
      EOH
    end
  end
end