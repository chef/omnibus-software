#!/usr/bin/env ruby

# Load the updated generate_steps.rb to test the deprecation logic
load File.join(__dir__, 'generate_steps.rb')

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

test_cases.each do |software, version, expected_deprecated|
  actual_deprecated = is_deprecated?(software, version)
  status = actual_deprecated == expected_deprecated ? "PASS" : "FAIL"
  
  puts "#{status}: #{software} #{version} -> #{actual_deprecated ? 'deprecated' : 'current'}"
end

puts "=" * 50
puts "Test completed!"
