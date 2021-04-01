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

name "automake"
default_version "1.16.3"

dependency "autoconf"
dependency "perl-thread-queue"

license "GPL-2.0"
license_file "COPYING"
skip_transitive_dependency_licensing true

version("1.16.3") { source sha256: "ce010788b51f64511a1e9bb2a1ec626037c6d0e7ede32c1c103611b9d3cba65f" }
version("1.16.2") { source sha256: "b2f361094b410b4acbf4efba7337bdb786335ca09eb2518635a09fb7319ca5c1" }

source url: "https://ftp.gnu.org/gnu/automake/automake-#{version}.tar.gz"

relative_path "automake-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  if version == "1.15"
    command "./bootstrap.sh", env: env
  else
    command "./bootstrap", env: env
  end
  command "./configure" \
          " --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
