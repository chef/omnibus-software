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

name "postgresql"
default_version "9.4.1"

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
# Version 9.6
#
version "9.6.10" do
  source sha256: "8615acc56646401f0ede97a767dfd27ce07a8ae9c952afdb57163b7234fe8426"
end

#
# Verison 9.5
#
version "9.5.14" do
  source sha256: "3e2cd5ea0117431f72c9917c1bbad578ea68732cb284d1691f37356ca0301a4d"
end

version "9.5.8" do
  source sha256: "ade57068f134f36710fa953e1ef79185abd96572f8098741413132f79ed37202"
end

version "9.5.1" do
  source md5: "11e037afaa4bd0c90bb3c3d955e2b401"
end

version "9.5.0" do
  source md5: "2f3264612ac32e5abdfb643fec934036"
end

version "9.5beta1" do
  source md5: "4bd67bfa4dc148e3f9d09f6699b5931f"
end

#
# Version 9.4
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
# Version 9.3 will EoL 2018-11 or thereabouts
#
version "9.3.24" do
  source sha256: "8214a73a3b2135226bdc1394c9efdcb80f79e504ec700cf9b23d0b6bc2b60da9"
end

version "9.3.18" do
  source sha256: "ad60d12a5a3dd0f6f5904c41b87e43eff49d3f74e45129fe52c5744366ff2fe0"
end

version "9.3.14" do
  source sha256: "5c4322f1c42ba1ff4b28383069c56663b46160bb08e85d41fa2ab9a5009d039d"
end

version "9.3.10" do
  source md5: "ec2365548d08f69c8023eddd4f2d1a28"
end

version "9.3.6" do
  source md5: "0212b03f2835fdd33126a2e70996be8e"
end

version "9.3.5" do
  source md5: "5059857c7d7e6ad83b6d55893a121b59"
end

version "9.3.4" do
  source md5: "d0a41f54c377b2d2fab4a003b0dac762"
end

#
# Version 9.2 was EoL 2017-11-06
#
version "9.2.24" do
  source sha256: "a754c02f7051c2f21e52f8669a421b50485afcde9a581674d6106326b189d126"
end

version "9.2.22" do
  source sha256: "a70e94fa58776b559a8f7b5301371ac4922c9e3ed313ccbef20862514de7c192"
end

version "9.2.21" do
  source sha256: "0697e843523ee60c563f987f9c65bc4201294b18525d6e5e4b2c50c6d4058ef9"
end

version "9.2.14" do
  source md5: "ce2e50565983a14995f5dbcd3c35b627"
end

version "9.2.10" do
  source md5: "7b81646e2eaf67598d719353bf6ee936"
end

version "9.2.9" do
  source md5: "38b0937c86d537d5044c599273066cfc"
end

version "9.2.8" do
  source md5: "c5c65a9b45ee53ead0b659be21ca1b97"
end

#
# Version 9.1 was EoL 2016-10-24 or thereabouts.
#
version "9.1.24" do
  source sha256: "de0d84e9f32af145fcd66d8d324f6ef1a0b17944ea344b7bbe9d99fff68ae5d3"
end

version "9.1.15" do
  source md5: "6ac52cf13ecf6b09c7d42928d1219cae"
end

version "9.1.9" do
  source md5: "6b5ea53dde48fcd79acfc8c196b83535"
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
