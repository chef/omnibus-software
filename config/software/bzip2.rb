#
# Copyright:: Copyright (c) 2013-2014 Chef Software, Inc.
# License:: Apache License, Version 2.0
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
# Install bzip2 and its shared library, libbz2.so
# This library object is required for building Python with the bz2 module,
# and should be picked up automatically when building Python.

# This is a Linux/OSX only DSL

name "bzip2"
default_version "1.0.8"

dependency "zlib"
dependency "openssl"

source url: "https://s3.amazonaws.com/dd-agent/bzip2/bzip2-#{version}.tar.gz",
       sha256: "ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269"

relative_path "#{name}-#{version}"

prefix = "#{install_dir}/embedded"
libdir = "#{prefix}/lib"

env = {
  "LDFLAGS" => "-L#{libdir} -I#{prefix}/include",
  "CFLAGS" => "-L#{libdir} -I#{prefix}/include -fPIC",
  "LD_RUN_PATH" => libdir,
}

build do
  license "BSD-style"
  license_file "https://sourceware.org/git/?p=bzip2.git;a=blob_plain;f=LICENSE;h=81a37eab7a5be1a34456f38adb74928cc9073e9b;hb=HEAD"
  patch source: "makefile_take_env_vars.patch"
  patch source: "soname_install_dir.patch" if ohai["platform_family"] == "mac_os_x"
  command "make PREFIX=#{prefix} VERSION=#{version}", env: env
  command "make PREFIX=#{prefix} VERSION=#{version} -f Makefile-libbz2_so", env: env
  command "make install VERSION=#{version} PREFIX=#{prefix}", env: env
end
