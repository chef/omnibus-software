#!/bin/bash

set -e

echo "=== OpenSSL Executable Validation ==="

FAILURES=()

# Check for OpenSSL in multiple possible locations
POSSIBLE_PATHS=(
    "/opt/test/embedded/bin/openssl"
    "/opt/omnibus-toolchain/embedded/bin/openssl"
    "/usr/bin/openssl"
)

OPENSSL_PATH=""
for path in "${POSSIBLE_PATHS[@]}"; do
    if [ -f "$path" ]; then
        OPENSSL_PATH="$path"
        echo "Found OpenSSL at: $OPENSSL_PATH"
        break
    fi
done

if [ -z "$OPENSSL_PATH" ]; then
    FAILURES+=("ERROR: OpenSSL not found in any expected location")
    FAILURES+=("Checked locations:")
    for path in "${POSSIBLE_PATHS[@]}"; do
        FAILURES+=("  - $path")
    done
    FAILURES+=("Searching for any OpenSSL installations...")
    find /opt -name "openssl" -type f 2>/dev/null || FAILURES+=("No OpenSSL executable found in /opt")
else
    # Test OpenSSL executable and providers
    echo "--- OpenSSL Version Information ---"
    $OPENSSL_PATH version -a

    echo ""
    echo "--- Testing OpenSSL providers ---"
    $OPENSSL_PATH list -providers

    echo ""
    echo "--- Testing legacy provider availability ---"
    providers_output=$($OPENSSL_PATH list -providers)
    if echo "$providers_output" | grep -qi "openssl legacy provider"; then
        echo "Legacy provider is available"
    else
        FAILURES+=("Legacy provider not available - 'OpenSSL Legacy Provider' not found in providers output")
    fi

    echo ""
    echo "--- Testing FIPS provider availability ---"
    if echo "$providers_output" | grep -qi "openssl fips provider"; then
        echo "FIPS provider is available"
    else
        FAILURES+=("FIPS provider not available - 'OpenSSL FIPS Provider' not found in providers output")
    fi
fi

if [ ${#FAILURES[@]} -ne 0 ]; then
    echo ""
    echo "=== Failures ==="
    for msg in "${FAILURES[@]}"; do
        echo "$msg"
    done
    exit 1
fi

echo ""
echo "All OpenSSL executable tests completed!"