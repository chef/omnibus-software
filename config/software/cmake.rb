#
# Copyright:: Chef Software, Inc.
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

name "cmake"
default_version "3.18.1"

dependency "cacerts"

license "BSD-3-Clause"
skip_transitive_dependency_licensing true
version("3.18.1") { source sha256: "c0e3338bd37e67155b9d1e9526fec326b5c541f74857771b7ffed0c46ad62508" }
minor_version = version.split(".")[0..1].join(".")

if windows?
  if windows_arch_i386?
    source url: "https://cmake.org/files/v#{minor_version}/cmake-#{version}-win32-x86.zip", sha256: "1a20c049e094d9ad49caca4b4d713c75c924a3885ecec4ed3986344aab05b6eb"
    relative_path "cmake-#{version}-win32-x86"
    license_file "doc/cmake/Copyright.txt"
  else
    source url: "https://cmake.org/files/v#{minor_version}/cmake-#{version}-win64-x64.zip", sha256: "2c6c06da43c1088fc3a673e4440c8ebb1531bb6511134892c0589aa0b94f11ad"
    relative_path "cmake-#{version}-win64-x64"
    license_file "doc/cmake/Copyright.txt"
  end
else
  source url: "https://cmake.org/files/v#{minor_version}/cmake-#{version}.tar.gz"
  relative_path "cmake-#{version}"
  license_file "Copyright.txt"
end

build do
  # It's hard-slash-impossible to build cmake on windows without cmake, so we don't even try
  if windows?
    copy "bin/cmake.exe", "#{install_dir}/embedded/bin"
    copy "share/cmake-3.18", "#{install_dir}/embedded/share/"
    copy "share/aclocal/cmake.m4", "#{install_dir}/embedded/share/aclocal/"
  else
    env = with_standard_compiler_flags(with_embedded_path)

    command "./bootstrap --prefix=#{install_dir}/embedded", env: env

    make "-j #{workers}", env: env
    make "install", env: env
  end
end
