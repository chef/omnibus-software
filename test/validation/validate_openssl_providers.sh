#!/bin/bash

set -e

echo "=== OpenSSL Providers Configuration Validation ==="

# Check if OpenSSL is installed - the test project installs to /opt/test
OPENSSL_PATH="/opt/test/embedded/bin/openssl"
if [ ! -f "$OPENSSL_PATH" ]; then
    echo "ERROR: OpenSSL not found at $OPENSSL_PATH"
    echo "Build may not have completed successfully or OpenSSL installation failed"
    echo "Checking alternative locations..."
    find /opt -name "openssl" -type f 2>/dev/null || echo "No OpenSSL executable found in /opt"
    exit 1
fi

echo "--- Checking OpenSSL configuration directory ---"
if [ -d "/opt/test/embedded/ssl/" ]; then
    echo "SSL config directory found:"
    ls -la /opt/test/embedded/ssl/ | head -10
else
    echo "SSL config directory not found"
fi

echo ""
echo "--- Checking for provider modules ---"
if [ -d "/opt/test/embedded/lib/ossl-modules/" ]; then
    echo "Provider modules directory found:"
    ls -la /opt/test/embedded/lib/ossl-modules/
else
    echo "Provider modules directory not found"
fi

echo ""
echo "--- Testing provider loading with configuration ---"
$OPENSSL_PATH list -providers -verbose

echo ""
echo "--- Testing legacy algorithms availability ---"
if echo 'test' | $OPENSSL_PATH dgst -md5 > /dev/null 2>&1; then
    echo "Legacy MD5 algorithm is available:"
    echo 'test' | $OPENSSL_PATH dgst -md5
else
    echo "Legacy MD5 not available (may be expected if legacy provider not loaded)"
fi

echo ""
echo "--- Testing modern algorithms ---"
echo "SHA-256 algorithm test:"
echo 'test' | $OPENSSL_PATH dgst -sha256

echo ""
echo "All OpenSSL provider configuration tests completed!"
