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
# expeditor/ignore: deprecated 2021-04

name "binutils"
default_version "2.26"

version("2.35") { source sha256: "a3ac62bae4f339855b5449cfa9b49df90c635adbd67ecb8a0e7f3ae86a058da6" }
version("2.26") { source sha256: "9615feddaeedc214d1a1ecd77b6697449c952eab69d79ab2125ea050e944bcc1" }

license "GPL-3.0"
license_file "COPYING"
license_file "COPYING.LIB"

source url: "https://ftp.gnu.org/gnu/binutils/binutils-#{version}.tar.gz"

dependency "config_guess"

relative_path "binutils-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  update_config_guess

  configure_command = ["./configure",
                     "--prefix=#{install_dir}/embedded",
                     "--disable-libquadmath"]

  command configure_command.join(" "), env: env

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end