#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
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

# We use the version in util-linux, and only build the libuuid subdirectory
name "libsodium"
default_version "0.7.1"

dependency "autoconf"
dependency "automake"
dependency "libtool"


# perhaps use git https://github.com/jedisct1/libsodium/
source url: "http://download.libsodium.org/libsodium/releases/libsodium-#{version}.tar.gz",
       md5: "c224fe3923d1dcfe418c65c8a7246316"

relative_path "libsodium-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  command "./configure" \
          " --prefix=#{install_dir}/embedded", env: env
  make "-j #{workers}", env: env
  make "install", env: env
end
