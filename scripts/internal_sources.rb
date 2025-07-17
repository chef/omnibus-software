#!/usr/bin/env ruby
require "net/http"
require "openssl"
require "tmpdir"
require "yaml"

ARTIFACTORY_REPO_URL = ENV["ARTIFACTORY_REPO_URL"] || "https://artifactory-internal.ps.chef.co/artifactory/omnibus-software-local"
ARTIFACTORY_TOKEN    = ENV["ARTIFACTORY_TOKEN"]
ARTIFACTORY_PASSWORD = ENV["ARTIFACTORY_PASSWORD"]
puts "Artifactory token length: #{ENV["ARTIFACTORY_TOKEN"] ? ENV["ARTIFACTORY_TOKEN"].size : 0}"

def print_usage
  puts "Must provide path to internal_sources.yml file."
  puts "Usage: ./internal_sources.rb <file path> [only]"
  puts "       <file path>: Path to an internal_sources.yml file."
  puts "       [only]: (Optional) Name of software to upload. Skips all others."
end

# Validate Artifactory checksum headers match expectations
def validate_checksum!(response, source)
  headers = {}
  response.each_header { |k, v| headers[k.downcase] = v }
  if source.key?("sha256")
    headers["x-checksum-sha256"] == source["sha256"]
  elsif source.key?("md5")
    headers["x-checksum-md5"] == source["md5"]
  elsif source.key?("sha1")
    headers["x-checksum-sha1"] == source["sha1"]
  else
    raise "Unknown checksum format supplied for '#{source["url"]}'"
  end
end

# True if Artifactory contains the file and checksum matches
def exists_in_artifactory?(name, source)
  uri = URI(ARTIFACTORY_REPO_URL)
  file_name = File.basename(source["url"])
  path = [uri.path, name, file_name].join("/").gsub(%r{/+}, "/")

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  response = http.head(path)
  return false unless response.code == "200"
  validate_checksum!(response, source)
end

def maybe_upload(name, source)
  unless exists_in_artifactory?(name, source)
    Dir.mktmpdir do |dir|
      puts "Downloading #{name} from #{source["url"]}"
      raise "Failed to download" unless system("wget -q -P #{dir} #{source["url"]}")

      file_name = File.basename(source["url"])
      downloaded_file = File.join(dir, file_name)
      repo_url = "#{ARTIFACTORY_REPO_URL}/#{name}/#{file_name}".gsub(%r{/+}, "/")

      if ARTIFACTORY_PASSWORD && !ARTIFACTORY_PASSWORD.empty?
        # Probably an API Key (X-JFrog-Art-Api)
        upload_cmd = "curl -sf -H 'X-JFrog-Art-Api:#{ARTIFACTORY_PASSWORD}' -T '#{downloaded_file}' '#{repo_url}'"
      elsif ARTIFACTORY_TOKEN && !ARTIFACTORY_TOKEN.empty?
        # Probably a Bearer token
        upload_cmd = "curl -sf -H 'Authorization: Bearer #{ARTIFACTORY_TOKEN}' -T '#{downloaded_file}' '#{repo_url}'"
      else
        raise "No ARTIFACTORY_PASSWORD or ARTIFACTORY_TOKEN defined for uploading!"
      end

      puts "Uploading #{downloaded_file} to #{repo_url}"
      unless system(upload_cmd)
        raise "Failed to upload #{downloaded_file} to Artifactory"
      end
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
