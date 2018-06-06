#
# Copyright 2012-2014 Chef Software, Inc.
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
default_version "3.11.3"

dependency "cacerts"

license "BSD-3-Clause"
skip_transitive_dependency_licensing true
version("3.11.3") { source sha256: "287135b6beb7ffc1ccd02707271080bbf14c21d80c067ae2c0040e5f3508c39a" }
minor_version = version.split(".")[0..1].join(".")

if windows?
  if windows_arch_i386?
    source url: "https://cmake.org/files/v#{minor_version}/cmake-#{version}-win32-x86.zip", sha256: "d444da334688451e467f72e7b3617900c4e39cb6dce44cb2ad650b0e7ced02d3"
    relative_path "cmake-#{version}-win32-x86"
    license_file "doc/cmake/Copyright.txt"
  else
    source url: "https://cmake.org/files/v#{minor_version}/cmake-#{version}-win64-x64.zip", sha256: "d275d176d7a249c6156b260d19a8049a2032c7e3f1bde04fcf13ce9c7ca895cd"
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
    copy "share/cmake-3.11", "#{install_dir}/embedded/share/"
    copy "share/aclocal/cmake.m4", "#{install_dir}/embedded/share/aclocal/"
  else
    env = with_standard_compiler_flags(with_embedded_path)

    command "./bootstrap --prefix=#{install_dir}/embedded", env: env

    make "-j #{workers}", env: env
    make "install", env: env
  end
end
