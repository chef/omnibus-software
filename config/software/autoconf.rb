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

name "autoconf"
default_version "2.71"

license "GPL-3.0"
license_file "COPYING"
license_file "COPYING.EXCEPTION"
skip_transitive_dependency_licensing true

dependency "m4"

version("2.71") { source sha256: "431075ad0bf529ef13cb41e9042c542381103e80015686222b8a9d4abef42a1c" }
version("2.70") { source sha256: "f05f410fda74323ada4bdc4610db37f8dbd556602ba65bc843edb4d4d4a1b2b7" }

source url: "https://ftp.gnu.org/gnu/autoconf/autoconf-#{version}.tar.gz"

relative_path "autoconf-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  if solaris2?
    env["M4"] = "#{install_dir}/embedded/bin/m4"
  end

  command "./configure" \
          " --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
