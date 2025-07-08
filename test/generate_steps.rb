#!/usr/bin/env ruby
require "open3"
# Get the branch to compare against (rename default to 'main' once migration occurs)
BRANCH = ENV["BUILDKITE_PULL_REQUEST_BASE_BRANCH"] || "main"

# Define deprecated software versions that are end-of-life
DEPRECATED_VERSIONS = {
  # Python 2.x (EOL January 1, 2020)
  "python" => ["2.7.18", "2.7.14", "2.7.9"],

  # OpenSSL 1.0.x (EOL)
  "openssl" => ["1.0.2zg", "1.0.2zb", "1.0.2za", "1.0.2ze", "1.0.2zf", "1.0.2zi"],

  # OpenSSL FIPS 2.0.x (EOL)
  "openssl-fips" => ["2.0.9", "2.0.10", "2.0.11", "2.0.14", "2.0.16"],

  # Node.js EOL versions
  "nodejs-binary" => ["6.7.0", "8.9.1", "9.2.0"],

  # Elasticsearch EOL versions
  "elasticsearch" => ["5.6.16", "6.8.22", "6.8.23"],

  # Go EOL versions (Go only supports last 2 major versions)
  "go" => ["1.16.3", "1.17.7", "1.17.6", "1.17.5", "1.17.2", "1.17", "1.18", "1.18.5", "1.18.3", "1.18.2", "1.19.5", "1.19.1", "1.19"],

  # PostgreSQL EOL versions
  "postgresql" => ["9.6.22", "9.3.25"],

  # RabbitMQ EOL versions
  "rabbitmq" => ["2.8.7", "2.7.1", "3.3.4"],

  # Perl EOL versions
  "perl" => ["5.18.1", "5.22.1", "5.30.0"],

  # Ruby 3.0.x (EOL March 2024)
  "ruby" => ["3.0.6", "3.0.5", "3.0.4", "3.0.3", "3.0.2", "3.0.1"],

  # Other legacy software
  "erlang" => ["18.3"],
  "ncurses" => ["5.9"],
  "expat" => ["2.1.0"],
  "libyaml" => ["0.1.7"],
  "lua" => ["5.2.4"],
  "git" => ["2.24.1"],
  "libffi" => ["3.3"],
  "libiconv" => ["1.15"],
  "binutils" => ["2.26"],
  "gtar" => ["1.29", "1.30"],
  "libtool" => ["2.4", "2.4.2"],
  "zlib" => ["1.2.6", "1.2.8"],
  "rsync" => ["2.6.9"],
}.freeze

# Check if a software/version combination is deprecated
def is_deprecated?(software, version)
  deprecated_versions = DEPRECATED_VERSIONS[software]
  return false unless deprecated_versions

  deprecated_versions.include?(version)
end

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

    # Add deprecated marker if this software/version is EOL
    deprecated_marker = is_deprecated?(software, version) ? " [deprecated]" : ""

    puts <<~EOH
      - label: "test-build (#{software} #{version})"
      - label: "test-build (#{software} #{version})#{deprecated_marker}"
        command: docker-compose run --rm -e SOFTWARE=#{software} -e VERSION=#{version} #{skip_health_check} -e CI builder
        timeout_in_minutes: 30
        expeditor:
          executor:
            linux:
              privileged: true
    EOH
  end
end
