#!/bin/bash

set -e

echo "=== OpenSSL Build and Providers Validation Wrapper ==="
echo "Building OpenSSL first..."

# Change to the test directory where omnibus-build.sh expects to be run
cd /test

export OMNIBUS_FIPS_MODE=true

# Run the build process first
bash --init-file omnibus-build.sh

echo ""
echo "Build completed. Checking if OpenSSL providers validation should run..."

# Only run validation if VERSION major is >= 3
if [ -n "$VERSION" ]; then
    # Extract major version number
    version_major=$(echo "$VERSION" | cut -d. -f1)
    
    if [ "$version_major" -ge 3 ]; then
        echo "OpenSSL version $VERSION (major >= 3), running providers validation..."
        /omnibus-software/test/validation/validate_openssl_providers.sh
    else
        echo "OpenSSL version $VERSION (major < 3), skipping providers validation"
    fi
else
    echo "VERSION environment variable not set, skipping validation"
fi
