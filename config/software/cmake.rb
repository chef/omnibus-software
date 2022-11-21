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
# expeditor/ignore: deprecated 2021-11

name "cmake"
default_version "3.19.7"

dependency "cacerts"

license "BSD-3-Clause"
skip_transitive_dependency_licensing true

if windows?
  if windows_arch_i386?
    # version_list: url=https://cmake.org/files/v3.20/ filter=*-windows-i386.zip
    version("3.20.0") { source sha256: "6df4c34f7d2735100ebae91e6d2d37b3c3c7b81e93decce9f4926a4e505affbc" }

    # version_list: url=https://cmake.org/files/v3.19/ filter=*-win32-x86.zip
    version("3.19.7") { source sha256: "7771205d94022787bc4c3a623629d236b10bf697315e9f92c214dd8b53e8746e" }

    # version_list: url=https://cmake.org/files/v3.18/ filter=*-win32-x86.zip
    version("3.18.6") { source sha256: "f6531568def18afecf3d54abd7ccf1f9cf092c683b14fde36b47910c7f822e8d" }
    version("3.18.1") { source sha256: "1a20c049e094d9ad49caca4b4d713c75c924a3885ecec4ed3986344aab05b6eb" }
  else
    # version_list: url=https://cmake.org/files/v3.20/ filter=*-windows-x86_64.zip
    version("3.20.0") { source sha256: "056378cb599353479c3a8aa2654454b8a3eaa3c8c0872928ba7e09c3ec50774c" }

    # version_list: url=https://cmake.org/files/v3.19/ filter=*-win64-x64.zip
    version("3.19.7") { source sha256: "e6788d6e23b3026c37fcfa7658075d6b5f9113f26fae17fe372ad4a7ee62d5fd" }

    # version_list: url=https://cmake.org/files/v3.18/ filter=*-win64-x64.zip
    version("3.18.6") { source sha256: "6a7166841bf2d72d56b5ff8c7c7606901bd8a0d87194f509b759d3ae3b6fdd6e" }
    version("3.18.1") { source sha256: "2c6c06da43c1088fc3a673e4440c8ebb1531bb6511134892c0589aa0b94f11ad" }
  end
else
  # version_list: url=https://cmake.org/files/v3.20/ filter=*.tar.gz
  version("3.20.0") { source sha256: "9c06b2ddf7c337e31d8201f6ebcd3bba86a9a033976a9aee207fe0c6971f4755" }

  # version_list: url=https://cmake.org/files/v3.19/ filter=*.tar.gz default_version=true
  version("3.19.7") { source sha256: "58a15f0d56a0afccc3cc5371234fce73fcc6c8f9dbd775d898e510b83175588e" }

  # version_list: url=https://cmake.org/files/v3.18/ filter=*.tar.gz
  version("3.18.6") { source sha256: "124f571ab70332da97a173cb794dfa09a5b20ccbb80a08e56570a500f47b6600" }
  version("3.18.1") { source sha256: "c0e3338bd37e67155b9d1e9526fec326b5c541f74857771b7ffed0c46ad62508" }
end

minor_version = version.split(".")[0..1].join(".")

if windows?
  if windows_arch_i386?
    suffix = version.satisfies?(">= 3.20") ? "windows-i386" : "win32-x86"
    source url: "https://cmake.org/files/v#{minor_version}/cmake-#{version}-#{suffix}.zip"
    internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}-#{suffix}.zip",
                    authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
    relative_path "cmake-#{version}-win32-x86"
    license_file "doc/cmake/Copyright.txt"
  else
    suffix = version.satisfies?(">= 3.20") ? "windows-x86_64" : "win32-x64"
    source url: "https://cmake.org/files/v#{minor_version}/cmake-#{version}-#{suffix}.zip"
    internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}-#{suffix}.zip",
                    authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
    relative_path "cmake-#{version}-win64-x64"
    license_file "doc/cmake/Copyright.txt"
  end
else
  source url: "https://cmake.org/files/v#{minor_version}/cmake-#{version}.tar.gz"
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                  authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
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
