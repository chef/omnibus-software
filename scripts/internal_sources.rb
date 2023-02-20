#!/usr/bin/env ruby
require "net/http"
require "openssl"
require "tmpdir"
require "yaml"

ARTIFACTORY_REPO_URL = ENV["ARTIFACTORY_REPO_URL"] || "https://artifactory-internal.ps.chef.co/artifactory/omnibus-software-local"
ARTIFACTORY_PASSWORD = ENV["ARTIFACTORY_PASSWORD"]

def print_usage
  puts "Must provide path to internal_sources.yml file."
  puts "Usage: ./internal_sources.rb <file path> [only]"
  puts ""
  puts "          <file path>: Path to an internal_sources.yml file."
  puts "          [only]: (Optional) Name of software to upload. Skips all others."
end

def validate_checksum!(response, source)
  if source.key?("sha256")
    response.header["x-checksum-sha256"] == source["sha256"]
  elsif source.key?("md5")
    response.header["x-checksum-md5"]  == source["md5"]
  elsif source.key?("sha1")
    response.header["x-checksum-sha1"] == source["sha1"]
  else
    raise "Unknown checksum format supplied for '#{source["url"]}'"
  end
end

def exists_in_artifactory?(name, source)
  uri = URI(ARTIFACTORY_REPO_URL)
  file_name = File.basename(source["url"])
  dir_name = name
  path = File.join(uri.path, dir_name, file_name)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  response = http.head(path)
  validate_checksum!(response, source)
end

def maybe_upload(name, source)
  unless exists_in_artifactory?(name, source)
    Dir.mktmpdir do |dir|
      puts "Downloading #{name} from #{source["url"]}"
      raise "Failed to download" unless system("wget -q -P #{dir} #{source["url"]}")

      file_name = File.basename(source["url"])
      downloaded_file = File.join(dir, file_name)
      repo_url = File.join(ARTIFACTORY_REPO_URL, name, file_name)
      puts "Uploading #{downloaded_file} to #{repo_url}"
      raise "Failed to upload" unless system("curl -s -H 'X-JFrog-Art-Api:#{ARTIFACTORY_PASSWORD}' -T '#{downloaded_file}' #{repo_url}")

      puts ""
    end
  else
    puts "#{File.basename(source["url"])} exists in artifactory already...skipping"
  end
end

if ARGV.size < 1 || ARGV.size > 2
  print_usage
  exit(1)
end

file_path = ARGV[0]
only = ARGV[1]

unless File.exist?(file_path)
  abort("File '#{file_path}' does not exist")
end

yaml = YAML.load_file file_path
yaml["software"].each do |software|
  next if only && software["name"] != only

  name = software["name"]
  software["sources"].each { |source| maybe_upload(name, source) }
end