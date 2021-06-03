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
default_version "13.3" # NOTE: This version is EoL, but many downstream users take the default, and we shouldn't break them

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

version("13.3") { source sha256: "3cd9454fa8c7a6255b6743b767700925ead1b9ab0d7a0f9dcb1151010f8eb4a1" }

# Version 12.x will EoL November 14, 2024
version("12.5") { source sha256: "bd0d25341d9578b5473c9506300022de26370879581f5fddd243a886ce79ff95" }

# Version 9.6 will EoL November 11, 2021
version("9.6.10") { source sha256: "8615acc56646401f0ede97a767dfd27ce07a8ae9c952afdb57163b7234fe8426" }

# Verison 9.5 was EoL February 11, 2021
version("9.5.14") { source sha256: "3e2cd5ea0117431f72c9917c1bbad578ea68732cb284d1691f37356ca0301a4d" }

# Version 9.4 was EoL February 13, 2020
version("9.4.19") { source sha256: "03776b036b2a05371083558e10c21cc4b90bde9eb3aff60299c4ce7c084c168b" }

# Version 9.3 was EoL November 8, 2018
version("9.3.24") { source sha256: "8214a73a3b2135226bdc1394c9efdcb80f79e504ec700cf9b23d0b6bc2b60da9" }

# This is left here for Supermarket as of 3.2021
version("9.3.18") { source sha256: "ad60d12a5a3dd0f6f5904c41b87e43eff49d3f74e45129fe52c5744366ff2fe0" }

# Version 9.2 was EoL November 9, 2017
version("9.2.24") { source sha256: "a754c02f7051c2f21e52f8669a421b50485afcde9a581674d6106326b189d126" }
  
# This is left here for reporting as of 3.2021
version("9.2.10") { source md5: "7b81646e2eaf67598d719353bf6ee936" }

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
