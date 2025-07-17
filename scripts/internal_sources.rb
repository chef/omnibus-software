#!/usr/bin/env ruby
require "net/http"
require "openssl"
require "tmpdir"
require "yaml"
require "fileutils"

ARTIFACTORY_REPO_URL = ENV["ARTIFACTORY_REPO_URL"] || "https://artifactory-internal.ps.chef.co/artifactory/omnibus-software-local"
ARTIFACTORY_TOKEN = ENV["ARTIFACTORY_TOKEN"]

def print_usage
  puts "Must provide path to internal_sources.yml file."
  puts "Usage: ./internal_sources.rb <file path> [only]"
  puts ""
  puts "          <file path>: Path to an internal_sources.yml file."
  puts "          [only]: (Optional) Name of software to upload. Skips all others."
end

def validate_checksum!(file_path, expected_checksum)
  actual_checksum = `sha256sum #{file_path}`.split.first
  unless actual_checksum == expected_checksum
    raise "Checksum validation failed for #{file_path}. Expected: #{expected_checksum}, Actual: #{actual_checksum}"
  end
end

def exists_in_artifactory?(url)
  uri = URI(url)
  request = Net::HTTP::Head.new(uri)
  request["Authorization"] = "Bearer #{ARTIFACTORY_TOKEN}" if ARTIFACTORY_TOKEN

  response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
    http.request(request)
  end

  response.code == "200"
end

def upload_to_artifactory(file_path, url)
  uri = URI(url)
  request = Net::HTTP::Put.new(uri)
  request["Authorization"] = "Bearer #{ARTIFACTORY_TOKEN}" if ARTIFACTORY_TOKEN
  request.body = File.read(file_path)

  response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
    http.request(request)
  end

  unless response.code == "201" || response.code == "200"
    raise "Failed to upload #{file_path} to #{url}. Response: #{response.code} #{response.message}"
  end

  puts "Successfully uploaded #{file_path} to #{url}"
end

def maybe_upload(name, source)
  dir = Dir.mktmpdir
  file_name = File.basename(source["url"])
  downloaded_file = File.join(dir, file_name)

  puts "Checking if #{name} exists in Artifactory..."
  if exists_in_artifactory?(source["url"])
    puts "#{name} already exists in Artifactory. Skipping download and upload."
  else
    puts "#{name} does not exist in Artifactory. Downloading and uploading..."
    raise "Failed to download #{source["url"]}" unless system("curl -s -o '#{downloaded_file}' '#{source["url"]}'")

    puts "Validating checksum for #{downloaded_file}"
    validate_checksum!(downloaded_file, source["sha256"])

    puts "Uploading #{name} to Artifactory..."
    upload_to_artifactory(downloaded_file, source["url"])
  end
ensure
  FileUtils.remove_entry(dir) if dir
end

if ARGV.length < 1 || ARGV.length > 2
  print_usage
  exit(1)
end

file_path = ARGV[0]
only = ARGV[1]

unless File.exist?(file_path)
  abort("File '#{file_path}' does not exist")
end

yaml = YAML.load_file(file_path)
yaml["software"].each do |software|
  next if only && software["name"] != only

  software["sources"].each do |source|
    maybe_upload(software["name"], source)
  end
end
