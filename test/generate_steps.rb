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
        command: docker-compose run --rm -e SOFTWARE=#{software} -e VERSION=#{version} #{skip_health_check} -e CI builder
        timeout_in_minutes: 30
        expeditor:
          executor:
            linux:
              privileged: true
    EOH
  end
end