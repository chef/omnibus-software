#
# Copyright:: Copyright (c) 2012-2017 Chef Software, Inc.
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
default_version "1.0.2"

license "ISC"
license_file "LICENSE"
skip_transitive_dependency_licensing true

# Depend on the msys2/mingw environment given to us and don't build our
# own build tools on windows.
unless windows?
  dependency "autoconf"
  dependency "automake"
  dependency "libtool"
end

# perhaps use git https://github.com/jedisct1/libsodium/
version "1.0.12" do
  source sha256: "b8648f1bb3a54b0251cf4ffa4f0d76ded13977d4fa7517d988f4c902dd8e2f95"
end
version "1.0.8" do
  source md5: "0a66b86fd3aab3fe4c858edcd2772760"
end
version "1.0.2" do
  source md5: "dc40eb23e293448c6fc908757738003f"
end
version "0.7.1" do
  source md5: "c224fe3923d1dcfe418c65c8a7246316"
end

if version.satisfies?(">= 1.0.9")
  source url: "https://download.libsodium.org/libsodium/releases/libsodium-#{version}.tar.gz"
else
  source url: "https://download.libsodium.org/libsodium/releases/old/libsodium-#{version}.tar.gz"
end

relative_path "libsodium-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  configure "--disable-dependency-tracking", env: env
  make "-j #{workers}", env: env
  make "install", env: env
end
