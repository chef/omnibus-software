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

name "gmp"
default_version "6.0.0a"

version("6.0.0a") { source md5: "b7ff2d88cae7f8085bd5006096eed470" }

source url: "https://ftp.gnu.org/gnu/gmp/gmp-#{version}.tar.bz2"

relative_path "gmp-6.0.0"

env = with_standard_compiler_flags(with_embedded_path)

if solaris2?
  env['ABI'] = "32"
end

build do
  configure_command = ["./configure",
                       "--prefix=#{install_dir}/embedded"]

  command configure_command.join(" "), env: env
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
