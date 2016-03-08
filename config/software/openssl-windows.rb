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

name "openssl-windows"
# 1.0.1s is binary imcompatible with ruby from rubyinstaller due to an API
# change removing SSLv2 functions.
default_version "1.0.1r"

dependency "ruby-windows"

if windows_arch_i386?
  version('1.0.1r') do
    source url: "https://github.com/jaym/windows-openssl-build/releases/download/openssl-1.0.1r/openssl-1.0.1r-x86-windows.tar.lzma",
           md5: "72e2cab647192ddc5314760feca6b424"
  end
  version('1.0.1s') do
    source url: "https://github.com/jaym/windows-openssl-build/releases/download/openssl-1.0.1s/openssl-1.0.1s-x86-windows.tar.lzma",
           md5: "971abfe54d89d79b34c7444dcab8e17b"
  end
else
  version('1.0.1r') do
    source url: "https://github.com/jaym/windows-openssl-build/releases/download/openssl-1.0.1r/openssl-1.0.1r-x64-windows.tar.lzma",
           md5: "d1aa3c43f21eaf42abf321cbfd9de331"
  end
  version('1.0.1s') do
    source url: "https://github.com/jaym/windows-openssl-build/releases/download/openssl-1.0.1s/openssl-1.0.1s-x64-windows.tar.lzma",
           md5: "0a8d444d22ab43ecf8ae29ec8d31fa1b"
  end
end

relative_path 'bin'

build do
  # Copy over the required dlls into embedded/bin
  copy "libeay32.dll", "#{install_dir}/embedded/bin/"
  copy "ssleay32.dll", "#{install_dir}/embedded/bin/"
end
