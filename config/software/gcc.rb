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

name "gcc"
default_version "4.9.2"

dependency "gmp"
dependency "mpfr"
dependency "mpc"
dependency "libiconv"

version("4.9.2")      { source md5: "76f464e0511c26c93425a9dcdc9134cf" }

source url: "http://mirrors.kernel.org/gnu/gcc/gcc-#{version}/gcc-#{version}.tar.gz"

relative_path "gcc-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  configure_command = ["./configure",
                     "--prefix=#{install_dir}/embedded",
                     "--disable-nls",
                     "--enable-languages=c,c++",
                     "--with-as=/usr/ccs/bin/as",
                     "--with-ld=/usr/ccs/bin/ld"]


  command configure_command.join(" "), env: env
  # gcc takes quite a long time to build (over 2 hours) so we're setting the mixlib shellout
  # timeout to 4 hours. It's not great but it's required (on solaris at least, need to verify
  # on any other platforms we may use this with)
  make "-j #{workers}", env: env, timeout: 14400
  make "-j #{workers} install", env: env
end
