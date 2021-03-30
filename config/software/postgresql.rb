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
default_version "9.2.24" # NOTE: This version is EoL, but many downstream users take the default, and we shouldn't break them

license "PostgreSQL"
license_file "COPYRIGHT"
skip_transitive_dependency_licensing true

dependency "zlib"
dependency "openssl"
dependency "libedit"
dependency "ncurses"
dependency "libossp-uuid"
dependency "config_guess"

#
# Version 12.x will EoL November 14, 2024
#
version "12.5" do
  source sha256: "bd0d25341d9578b5473c9506300022de26370879581f5fddd243a886ce79ff95",
  url: "https://ftp.postgresql.org/pub/source/v12.5/postgresql-12.5.tar.bz2"
end

#
# Version 9.6 will EoL November 11, 2021
#
version "9.6.10" do
  source sha256: "8615acc56646401f0ede97a767dfd27ce07a8ae9c952afdb57163b7234fe8426"
end

#
# Verison 9.5 was EoL February 11, 2021
#
version "9.5.14" do
  source sha256: "3e2cd5ea0117431f72c9917c1bbad578ea68732cb284d1691f37356ca0301a4d"
end

#
# Version 9.4 was EoL February 13, 2020
#
version "9.4.19" do
  source sha256: "03776b036b2a05371083558e10c21cc4b90bde9eb3aff60299c4ce7c084c168b"
end

version "9.4.13" do
  source sha256: "0080f55d65194de8b96a2dab153443f8248ff2b2b10e6ab4cda2dcadcac7f2ab"
end

version "9.4.6" do
  source md5: "0371b9d4fb995062c040ea5c3c1c971e"
end

version "9.4.5" do
  source md5: "8b2e3472a8dc786649b4d02d02e039a0"
end

version "9.4.1" do
  source md5: "2cf30f50099ff1109d0aa517408f8eff"
end

version "9.4.0" do
  source md5: "8cd6e33e1f8d4d2362c8c08bd0e8802b"
end

#
# Version 9.3 was EoL November 8, 2018
#
version "9.3.24" do
  source sha256: "8214a73a3b2135226bdc1394c9efdcb80f79e504ec700cf9b23d0b6bc2b60da9"
end

# This is left here for Supermarket as of 3.2021
version "9.3.18" do
  source sha256: "ad60d12a5a3dd0f6f5904c41b87e43eff49d3f74e45129fe52c5744366ff2fe0"
end

#
# Version 9.2 was EoL November 9, 2017
#
version "9.2.24" do
  source sha256: "a754c02f7051c2f21e52f8669a421b50485afcde9a581674d6106326b189d126"
end

# This is left here for reporting as of 3.2021
version "9.2.10" do
  source md5: "7b81646e2eaf67598d719353bf6ee936"
end

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
