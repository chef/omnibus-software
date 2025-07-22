#!/opt/test/embedded/bin/ruby

# Check if the omnibus Ruby is installed (this should exist after build)
# The test project installs to /opt/test
omnibus_ruby = "/opt/test/embedded/bin/ruby"
unless File.exist?(omnibus_ruby)
  puts "ERROR: Omnibus Ruby not found at #{omnibus_ruby}"
  puts "Build may not have completed successfully or Ruby installation failed"
  puts "Checking alternative locations..."
  begin
    paths = Dir.glob("/opt/*/embedded/bin/ruby")
    if paths.any?
      puts "Found Ruby installations at: #{paths.join(", ")}"
    else
      puts "No omnibus Ruby installations found in /opt"
    end
  rescue => e
    puts "Error searching for Ruby: #{e.message}"
  end
  exit 1
end

# Use the omnibus Ruby to run the actual tests
exec(omnibus_ruby, "-e", <<~RUBY_CODE)
  # Check if OpenSSL library exists
  unless File.exist?("/opt/test/embedded/lib") && Dir.glob("/opt/test/embedded/lib/*ssl*").any?
    puts "ERROR: OpenSSL libraries not found in /opt/test/embedded/lib"
    puts "Build may not have completed successfully or OpenSSL installation failed"
    exit 1
  end

  require "openssl"

  # Get expected version from environment variable
  expected_version = ENV['VERSION']

  errors = []
  puts "--- Ruby OpenSSL Library Version ---"
  puts "OpenSSL::OPENSSL_LIBRARY_VERSION: \#{OpenSSL::OPENSSL_LIBRARY_VERSION}"
  if expected_version && !OpenSSL::OPENSSL_LIBRARY_VERSION.include?(expected_version)
    errors << "OpenSSL library version mismatch: expected to contain \#{expected_version}, got \#{OpenSSL::OPENSSL_LIBRARY_VERSION}"
  end

  puts "OpenSSL::OPENSSL_VERSION: \#{OpenSSL::OPENSSL_VERSION}"
  puts "--- Testing FIPS mode capability ---"
  begin
    if OpenSSL.respond_to?(:fips_mode)
      puts "FIPS mode available: \#{OpenSSL.fips_mode}"
      puts "Attempting to enable FIPS mode..."
      # Try to enable FIPS mode (may fail if FIPS provider not configured)
      begin
        OpenSSL.fips_mode = true
        puts "FIPS mode enabled successfully: \#{OpenSSL.fips_mode}"
        OpenSSL.fips_mode = false
        puts "FIPS mode disabled successfully: \#{OpenSSL.fips_mode}"
      rescue => e
        puts "FIPS mode activation failed (expected if FIPS provider not configured): \#{e.message}"
      end
    else
      puts "FIPS mode methods not available (OpenSSL < 3.0 or Ruby OpenSSL gem limitation)"
      errors << "FIPS mode methods not available (OpenSSL < 3.0 or Ruby OpenSSL gem limitation)"
    end
  rescue => e
    puts "Error testing FIPS mode: \#{e.message}"
    errors << "Error testing FIPS mode: \#{e.message}"
  end

  puts "--- Testing basic cryptographic operations ---"
  begin
    # Test basic encryption/decryption
    cipher = OpenSSL::Cipher.new("AES-256-CBC")
    cipher.encrypt
    key = cipher.random_key
    iv = cipher.random_iv
    encrypted = cipher.update("test data") + cipher.final
  #{"  "}
    cipher.decrypt
    cipher.key = key
    cipher.iv = iv
    decrypted = cipher.update(encrypted) + cipher.final
  #{"  "}
    if decrypted == "test data"
      puts "Basic AES-256-CBC encryption/decryption: PASS"
    else
      puts "Basic AES-256-CBC encryption/decryption: FAIL"
      errors << "Basic AES-256-CBC encryption/decryption: FAIL"
    end
  rescue => e
    puts "Cryptographic operation failed: \#{e.message}"
    errors << "Cryptographic operation failed: \#{e.message}"
  end

  unless errors.empty?
    puts "Errors encountered during OpenSSL validation:"
    errors.each { |error| puts "- \#{error}" }
    exit 1
  end

  puts "All OpenSSL Ruby integration tests passed!"
RUBY_CODE
