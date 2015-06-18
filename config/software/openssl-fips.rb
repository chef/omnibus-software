#
# Copyright 2014 Chef Software, Inc.
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

name "openssl-fips"
default_version "2.0.9"

version("2.0.9") { source md5: "c8256051d7a76471c6ad4fb771404e60" }

source url: "https://www.openssl.org/source/openssl-fips-#{version}.tar.gz"

relative_path "openssl-fips-#{version}"

#env = with_standard_compiler_flags(with_embedded_path)

build do
  # According to the FIPS manual, this is the only environment you are allowed
  # to build it in, to ensure security.
  env = {}
  env['FIPSDIR'] = "#{install_dir}/embedded"

  configure_command = ["./config"]

  command configure_command.join(" "), env: env
  make env: env
  make "install", env: env
end
