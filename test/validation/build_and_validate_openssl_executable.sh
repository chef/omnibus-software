#!/bin/bash

set -e

echo "=== OpenSSL Build and Validation Wrapper ==="
echo "Building OpenSSL first..."

# Change to the test directory where omnibus-build.sh expects to be run
cd /test

export OMNIBUS_FIPS_MODE=true
# Run the build process first
bash --init-file omnibus-build.sh

echo ""
echo "Build completed. Checking if OpenSSL validation should run..."

# Only run validation if VERSION is >= 3.0.0
if [ -n "$VERSION" ]; then
    # Use version comparison - convert VERSION to comparable format
    version_major=$(echo "$VERSION" | cut -d. -f1)
    
    if [ "$version_major" -ge 3 ]; then
        echo "OpenSSL version $VERSION >= 3.0.0, running executable validation..."
        /omnibus-software/test/validation/validate_openssl_executable.sh
    else
        echo "OpenSSL version $VERSION < 3.0.0, skipping executable validation"
    fi
else
    echo "VERSION environment variable not set, skipping validation"
fi
