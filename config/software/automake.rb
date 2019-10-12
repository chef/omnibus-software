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
default_version "1.11.2"

dependency "autoconf"

license "GPL-2.0"
license_file "COPYING"
skip_transitive_dependency_licensing true

version("1.16") { source md5: "7fb7155e553dc559ac39cf525f0bb5de" }
version("1.15") { source md5: "716946a105ca228ab545fc37a70df3a3" }
version("1.11.2") { source md5: "79ad64a9f6e83ea98d6964cef8d8a0bc" }

source url: "https://ftp.gnu.org/gnu/automake/automake-#{version}.tar.gz"

relative_path "automake-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  if version.satisfies?(">= 1.15") && version.satisfies?("< 1.16")
    command "./bootstrap.sh", env: env
  else
    command "./bootstrap", env: env
  end
  command "./configure" \
          " --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
