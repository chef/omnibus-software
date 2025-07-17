#!/bin/bash

set -e

echo "=== OpenSSL Build and Ruby Validation Wrapper ==="
echo "Building OpenSSL first..."

# Change to the test directory where omnibus-build.sh expects to be run
cd /test


export OMNIBUS_FIPS_MODE=true

# Run the build process first
bash --init-file omnibus-build.sh

echo ""
echo "Build completed. Running OpenSSL Ruby integration validation..."


export CI_OPENSSL_VERSION=$VERSION
export SOFTWARE=ruby
export VERSION=3.1.6

bash --init-file omnibus-build.sh

export VERSION=$CI_OPENSSL_VERSION

# Now run the actual validation
/omnibus-software/test/validation/validate_openssl_ruby.rb
