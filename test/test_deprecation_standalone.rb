#!/usr/bin/env ruby

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
  "rsync" => ["2.6.9"]
}

# Check if a software/version combination is deprecated
def is_deprecated?(software, version)
  deprecated_versions = DEPRECATED_VERSIONS[software]
  return false unless deprecated_versions
  deprecated_versions.include?(version)
end

# Test cases
test_cases = [
  ["python", "2.7.18", true],   # Should be deprecated
  ["python", "3.12.0", false], # Should not be deprecated
  ["openssl", "1.0.2zg", true], # Should be deprecated
  ["openssl", "3.4.1", false],  # Should not be deprecated
  ["go", "1.19.5", true],       # Should be deprecated
  ["go", "1.23.9", false],      # Should not be deprecated
  ["ruby", "3.0.6", true],      # Should be deprecated
  ["ruby", "3.3.1", false],     # Should not be deprecated
  ["zlib", "1.2.6", true],      # Should be deprecated
  ["zlib", "1.3.1", false],     # Should not be deprecated
]

puts "Testing deprecation logic:"
puts "=" * 50

all_passed = true
test_cases.each do |software, version, expected_deprecated|
  actual_deprecated = is_deprecated?(software, version)
  status = actual_deprecated == expected_deprecated ? "PASS" : "FAIL"
  
  if actual_deprecated != expected_deprecated
    all_passed = false
  end
  
  puts "#{status}: #{software} #{version} -> #{actual_deprecated ? 'deprecated' : 'current'}"
end

puts "=" * 50
puts "Test #{all_passed ? 'PASSED' : 'FAILED'}!"

# Test the label generation
puts "\nTesting label generation:"
puts "=" * 50

["python", "2.7.18"].tap do |software, version|
  deprecated_marker = is_deprecated?(software, version) ? " [deprecated]" : ""
  puts "Label: \"test-build (#{software} #{version})#{deprecated_marker}\""
end

["python", "3.12.0"].tap do |software, version|
  deprecated_marker = is_deprecated?(software, version) ? " [deprecated]" : ""
  puts "Label: \"test-build (#{software} #{version})#{deprecated_marker}\""
end
