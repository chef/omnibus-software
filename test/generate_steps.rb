#!/usr/bin/env ruby

require "open3"

# Disable the warning about redefining Object#method_missing
$VERBOSE = nil

# Get the branch to compare against (rename default to 'main' once migration occurs)
BRANCH = ENV["BUILDKITE_PULL_REQUEST_BASE_BRANCH"] || "main"

# Read in all the versions that are specified by SOFTWARE
def version(version = nil, &block)
  $versions << version
end

def default_version(version = nil)
  $versions << version
end

# Ignore all the other DSL methods in the file, we don't care about them now
def method_missing(m, *args, &block)
  # ignore
end

# Get a list of all the config/software definitions that have been added or modified
_, status = Open3.capture2e("git fetch origin #{BRANCH}")
exit 1 if status != 0
stdout, status = Open3.capture2("git diff --name-status HEAD origin/#{BRANCH} config/software | awk 'match($1, \"A\"){print $2; next} match($1, \"M\"){print $2}'")
exit 1 if status != 0

files = stdout.lines.compact.uniq.map(&:chomp)
exit 0 if files.empty?

puts "steps:"
files.each do |file|
  software = File.basename(file, ".rb")
  $versions = []

  load file

  $versions.compact.uniq.each do |version|
    puts <<~EOH
      - label: "test-build (#{software} #{version})"
        command: docker build --build-arg SOFTWARE=#{software} --build-arg VERSION=#{version} .
        timeout_in_minutes: 30
        expeditor:
          executor:
            linux:
              privileged: true
    EOH
  end
end