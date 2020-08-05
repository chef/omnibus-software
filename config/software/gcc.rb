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

version("4.9.2") { source sha256: "3e573826ec8b0d62d47821408fbc58721cd020df3e594cd492508de487a43b5e" }
version("4.9.3") { source sha256: "e6c63b40877bc756cc7cfe6ca98013eb15f02ec6c8c2cf68e24533ad1203aaba" }
version("5.3.0") { source sha256: "b7f5f56bd7db6f4fcaa95511dbf69fc596115b976b5352c06531c2fc95ece2f4" }
version("10.2.0") { source sha256: "27e879dccc639cd7b0cc08ed575c1669492579529b53c9ff27b0b96265fa867d" }

source url: "https://mirrors.kernel.org/gnu/gcc/gcc-#{version}/gcc-#{version}.tar.gz"

relative_path "gcc-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  configure_command = ["./configure",
                     "--prefix=#{install_dir}/embedded",
                     "--disable-nls",
                     "--enable-languages=c,c++",
                     "--disable-multilib"]

  command configure_command.join(" "), env: env
  # gcc takes quite a long time to build (over 2 hours) so we're setting the mixlib shellout
  # timeout to 4 hours. It's not great but it's required (on solaris at least, need to verify
  # on any other platforms we may use this with)
  # gcc also has issues on a lot of platforms when running a multithreaded job,
  # so unfortunately we have to build with 1 worker :(
  make env: env, timeout: 14400
  make "install", env: env
end
