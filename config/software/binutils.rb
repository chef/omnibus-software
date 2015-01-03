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

name "binutils"
default_version "2.24"

version("2.24") { source md5: "a5dd5dd2d212a282cc1d4a84633e0d88" }

source url: "http://ftp.gnu.org/gnu/binutils/binutils-#{version}.tar.gz"

relative_path "binutils-#{version}"

env = with_standard_compiler_flags(with_embedded_path)

build do
  configure_command = ["./configure",
                       "--enable-64-bit-bfd",
                       "--disable-werror",
                       "--prefix=#{install_dir}/embedded"]

  command configure_command.join(" "), env: env
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
