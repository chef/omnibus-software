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

name "libtool"
default_version "2.4"

skip_transitive_dependency_licensing true

dependency "config_guess"

version("2.4")   { source sha256: "13df57ab63a94e196c5d6e95d64e53262834fe780d5e82c28f177f9f71ddf62e" }

source url: "https://ftp.gnu.org/gnu/libtool/libtool-#{version}.tar.gz"

relative_path "libtool-#{version}"

build do
  license "GPL-2.0"
  license_file "./COPYING"

  env = with_standard_compiler_flags(with_embedded_path)

  update_config_guess
  update_config_guess(target: "libltdl/config")

  if aix?
    env["M4"] = "/opt/freeware/bin/m4"
  end

  mkdir "/tmp/build/embedded"
  command "./configure" \
          " --prefix=/tmp/build/embedded", env: env

  command "make -j #{workers}", env: env
  command "make install", env: env
end
