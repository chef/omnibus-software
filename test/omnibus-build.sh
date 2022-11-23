#!/bin/bash

# shellcheck disable=SC1090
. ~/.bashrc

echo "--- Setting Omnibus build environment variables"

export PATH="/opt/omnibus-toolchain/bin:${PATH}"
echo "PATH=${PATH}"

if [[ -f "/opt/omnibus-toolchain/embedded/ssl/certs/cacert.pem" ]]; then
  export SSL_CERT_FILE="/opt/omnibus-toolchain/embedded/ssl/certs/cacert.pem"
  echo "SSL_CERT_FILE=${SSL_CERT_FILE}"
fi

if [[ $SOFTWARE == "libxslt" ]]; then
  echo "--- Installing libxml2-dev for libxslt"
  apt-get install -y libxml2-dev
fi

###################################################################
# Query tool versions
###################################################################
echo ""
echo ""
echo "========================================"
echo "= Tool Versions"
echo "========================================"
echo ""
echo "Bash.........$(bash --version | head -1)"
echo "Bundler......$(bundle --version | head -1)"
echo "GCC..........$(gcc --version | head -1)"
echo "Git..........$(git --version | head -1)"
echo "Make.........$(make --version | head -1)"
echo "Ruby.........$(ruby --version | head -1)"
echo "RubyGems.....$(gem --version | head -1)"
echo ""
echo "========================================"

rm -f Gemfile.lock
rm -rf .bundle

if [[ $CI == true ]]; then
  DEBUG=1 bundle config set --local without development
fi

echo "--- Running bundle install"

DEBUG=1 bundle install

if [[ $CI == true ]]; then
  echo "--- Building"
  bundle exec omnibus build test
  exit $?
fi
