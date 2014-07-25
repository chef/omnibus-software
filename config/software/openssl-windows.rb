#
# Copyright 2014 Opscode, Inc.omnibus
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
name "openssl-windows"
default_version "1.0.0m"

dependency "ruby-windows"

source :url => "http://packages.openknapsack.org/openssl/openssl-#{version}-x86-windows.tar.lzma",
       :md5 => "1836409f45d3045243bb2653ad263f11"

build do
  # Make sure the OpenSSL version is suitable for our path:
  # OpenSSL version is something like
  # OpenSSL 1.0.0k 5 Feb 2013
  ruby "-e \"require 'openssl'; puts 'OpenSSL patch version check expecting <= 1.0.0l'; exit(1) if OpenSSL::OPENSSL_VERSION.split(' ')[1] >= '1.0.0m'\""

  temp_directory = File.join(Config.cache_dir, "openssl-cache")

  # Ensure the directory exists
  mkdir temp_directory
  # First extract the tar file out of lzma archive.
  command "7z.exe x #{project_file} -o#{temp_directory} -r -y"
  # Now extract the files out of tar archive.
  command "7z.exe x #{File.join(temp_directory, "openssl-#{version}-x86-windows.tar")} -o#{temp_directory} -r -y"
  # Copy over the required dlls into embedded/bin
  ["libeay32.dll", "ssleay32.dll"].each do |dll|
    copy("#{temp_directory}/bin/#{dll}", "#{install_dir}/embedded/bin/#{dll}")
  end
end
