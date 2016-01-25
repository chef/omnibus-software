#
# Copyright 2014 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# openssl 1.0.0m fixes a security vulnerability:
#   https://www.openssl.org/news/secadv_20140605.txt
# Since the rubyinstaller.org doesn't release ruby when a dependency gets
# patched, we are manually patching the dependency until we get a new
# ruby release on windows.
# This component should be removed when we upgrade to the next version of
# rubyinstaller > 1.9.3-p545 and 2.0.0-p451
#
# openssl 1.0.0n fixes more security vulnerabilities...
#   https://www.openssl.org/news/secadv_20140806.txt

# Ruby 2.0.0 doesn't support openssl 1.0.1 - so we still need to maintain 1.0.0
# series for those rubies.

name "openssl-windows"
default_version "1.0.1q"

dependency "ruby-windows"

if windows_arch_i386?
  version('1.0.1q') do
    source url: "https://github.com/jaym/windows-openssl-build/releases/download/openssl-1.0.1q/openssl-1.0.1q-x86-windows.tar.lzma",
           md5: "3970fb1323b89c068525d60211670528"
  end
else
  version('1.0.1q') do
    source url: "https://github.com/jaym/windows-openssl-build/releases/download/openssl-1.0.1q/openssl-1.0.1q-x64-windows.tar.lzma",
           md5: "c9a05a9dfed1b91674ccfbb0b9e731c9"
  end
end

relative_path 'bin'

build do
  # Make sure the OpenSSL version is suitable for our path:
  # OpenSSL version is something like
  # OpenSSL 1.0.0k 5 Feb 2013
  ruby "-e \"require 'openssl'; puts 'OpenSSL patch version check expecting <= #{version}'; puts 'Current version : ' + OpenSSL::OPENSSL_VERSION; exit(1) if OpenSSL::OPENSSL_VERSION.split(' ')[1] >= '#{version}'\""

  # Copy over the required dlls into embedded/bin
  copy "libeay32.dll", "#{install_dir}/embedded/bin/"
  copy "ssleay32.dll", "#{install_dir}/embedded/bin/"

  # Also copy over the openssl executable for debugging
  copy "bin/openssl.exe", "#{install_dir}/embedded/bin/"
end
