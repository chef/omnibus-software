#!/bin/bash

# shellcheck disable=SC1090
. ~/.bashrc

# shellcheck disable=SC1091
. /opt/omnibus-toolchain/bin/load-omnibus-toolchain

rm -f Gemfile.lock
rm -rf .bundle

if [[ $CI == true ]]; then
  DEBUG=1 bundle config set --local without development
fi

DEBUG=1 bundle install

if [[ $CI == true ]]; then
  bundle exec omnibus build test
  exit $?
fi
