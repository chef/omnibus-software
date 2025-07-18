#!/usr/bin/env ruby
require "net/http"
require "openssl"
require "tmpdir"
require "yaml"

def print_usage
  puts "Must provide path to internal_sources.yml file."
  puts "Usage: ./internal_sources.rb <file path> [only]"
  puts "       <file path>: Path to an internal_sources.yml file."
  puts "       [only]: (Optional) Name of software to upload. Skips all others."
end

def vault_available?
  system("which vault > /dev/null 2>&1")
end

# Set environment variables if not in "chef-oss" organization
if ENV["BUILDKITE_ORGANIZATION_SLUG"] != "chef-oss"
  unless vault_available?
    abort "The 'vault' CLI is required but not found in PATH. Please install it in your build environment."
  end

  ENV["VAULT_ADDR"] = "https://vault.ps.chef.co"

  vault_token_cmd = "vault login -method=aws -path=aws/private-cd -token-only header_value=vault.ps.chef.co role=ci"
  vault_token = `#{vault_token_cmd}`.strip
  if vault_token.nil? || vault_token.empty?
    abort "Failed to obtain VAULT_TOKEN. Check vault agent, AWS method, or credentials."
  end
  ENV["VAULT_TOKEN"] = vault_token

  # Prefer "token" field, fallback to "password", fail gracefully if neither present
  artifactory_token_cmd = "vault kv get -field token account/static/artifactory/buildkite 2>/dev/null || vault kv get -field password account/static/artifactory/buildkite 2>/dev/null || echo ''"
  artifactory_token = `#{artifactory_token_cmd}`.strip
  if artifactory_token.nil? || artifactory_token.empty?
    abort "Failed to obtain ARTIFACTORY_TOKEN from Vault."
  end
  ENV["ARTIFACTORY_TOKEN"] = artifactory_token
  ENV["ARTIFACTORY_PASSWORD"] = artifactory_token

  # Debug: Print only token length for security
  puts "[DEBUG] Artifactory token length: #{ENV["ARTIFACTORY_TOKEN"].size}"
end

ARTIFACTORY_REPO_URL = ENV.fetch("ARTIFACTORY_REPO_URL", "https://artifactory-internal.ps.chef.co/artifactory/omnibus-software-local")
ARTIFACTORY_TOKEN    = ENV["ARTIFACTORY_TOKEN"]
ARTIFACTORY_PASSWORD = ENV["ARTIFACTORY_PASSWORD"]

unless ARTIFACTORY_TOKEN && !ARTIFACTORY_TOKEN.empty?
  abort "ARTIFACTORY_TOKEN is not set!"
end

puts "[DEBUG] Using artifactory repo: #{ARTIFACTORY_REPO_URL}"
puts "[DEBUG] Artifactory token length: #{ARTIFACTORY_TOKEN.size}"

# Validate Artifactory checksum headers match expectations
def validate_checksum!(response, source)
  headers = {}
  response.each_header { |k, v| headers[k.downcase] = v }
  if source.key?("sha256")
    unless headers["x-checksum-sha256"] == source["sha256"]
      raise "SHA256 checksum mismatch in Artifactory for '#{source["url"]}'"
    end
  elsif source.key?("md5")
    unless headers["x-checksum-md5"] == source["md5"]
      raise "MD5 checksum mismatch in Artifactory for '#{source["url"]}'"
    end
  elsif source.key?("sha1")
    unless headers["x-checksum-sha1"] == source["sha1"]
      raise "SHA1 checksum mismatch in Artifactory for '#{source["url"]}'"
    end
  else
    raise "Unknown checksum format supplied for '#{source["url"]}'"
  end
end

# True if Artifactory contains the file and checksum matches
def exists_in_artifactory?(name, source)
  uri = URI(ARTIFACTORY_REPO_URL)
  file_name = File.basename(source["url"])
  path = [uri.path, name, file_name].join("/").gsub(%r{/+}, "/")
  full_url = "#{uri.scheme}://#{uri.host}:#{uri.port}#{path}"

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == "https"
  request = Net::HTTP::Head.new(path)
  request["X-JFrog-Art-Api"] = ARTIFACTORY_PASSWORD if ARTIFACTORY_PASSWORD && !ARTIFACTORY_PASSWORD.empty?
  request["Authorization"] = "Bearer #{ARTIFACTORY_TOKEN}" if ARTIFACTORY_TOKEN && !ARTIFACTORY_TOKEN.empty?
  response = http.request(request)
  return false unless response.code == "200"
  validate_checksum!(response, source)
end

def maybe_upload(name, source)
  unless exists_in_artifactory?(name, source)
    Dir.mktmpdir do |dir|
      puts "Downloading #{name} from #{source["url"]}"
      unless system("wget -q -P #{dir} #{source["url"]}")
        raise "Failed to download #{source["url"]}"
      end

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
    puts "#{File.basename(source["url"])} exists in Artifactory already...skipping"
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
  software["sources"].each { |source| maybe_upload(software["name"], source) }
end

puts "Done."
