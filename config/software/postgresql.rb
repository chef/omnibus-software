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

name "postgresql"
default_version "15.0"

license "PostgreSQL"
license_file "COPYRIGHT"
skip_transitive_dependency_licensing true

dependency "zlib"
dependency "openssl"
dependency "libedit"
dependency "ncurses"
dependency "libossp-uuid"
dependency "config_guess"

# version_list: url=https://ftp.postgresql.org/pub/source/v#{version}/ filter=*.tar.bz2

version("15.0")   { source sha256: "72ec74f4a7c16e684f43ea42e215497fcd4c55d028a68fb72e99e61ff40da4d6" }
version("14.5")   { source sha256: "d4f72cb5fb857c9a9f75ec8cf091a1771272802f2178f0b2e65b7b6ff64f4a30" }
version("14.4")   { source sha256: "c23b6237c5231c791511bdc79098617d6852e9e3bdf360efd8b5d15a1a3d8f6a" }
version("14.3")   { source sha256: "279057368bf59a919c05ada8f95c5e04abb43e74b9a2a69c3d46a20e07a9af38" }
version("14.2")   { source sha256: "2cf78b2e468912f8101d695db5340cf313c2e9f68a612fb71427524e8c9a977a" }
version("14.1")   { source sha256: "4d3c101ea7ae38982f06bdc73758b53727fb6402ecd9382006fa5ecc7c2ca41f" }
version("13.6")   { source sha256: "bafc7fa3d9d4da8fe71b84c63ba8bdfe8092935c30c0aa85c24b2c08508f67fc" }
version("13.5")   { source sha256: "9b81067a55edbaabc418aacef457dd8477642827499560b00615a6ea6c13f6b3" }
version("13.3")   { source sha256: "3cd9454fa8c7a6255b6743b767700925ead1b9ab0d7a0f9dcb1151010f8eb4a1" }

# Version 12.x will EoL November 14, 2024
version("12.7")   { source sha256: "8490741f47c88edc8b6624af009ce19fda4dc9b31c4469ce2551d84075d5d995" }

# Version 9.6 will EoL November 11, 2021
version("9.6.22") { source sha256: "3d32cd101025a0556813397c69feff3df3d63736adb8adeaf365c522f39f2930" }

# Version 9.3 was EoL November 8, 2018 (but used in Supermarket as of 6.2021)
version("9.3.25") { source sha256: "e4953e80415d039ccd33d34be74526a090fd585cf93f296cd9c593972504b6db" }

source url: "https://ftp.postgresql.org/pub/source/v#{version}/postgresql-#{version}.tar.bz2"

relative_path "postgresql-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  update_config_guess(target: "config")

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --with-libedit-preferred" \
          " --with-openssl" \
          " --with-ossp-uuid" \
          " --with-includes=#{install_dir}/embedded/include" \
          " --with-libraries=#{install_dir}/embedded/lib", env: env

  make "world -j #{workers}", env: env
  make "install-world", env: env
end
