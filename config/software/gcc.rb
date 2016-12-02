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

version("4.9.3")      { source md5: "648bfba342bb41a4b5350fb685f85bc5" }
version("4.9.2")      { source md5: "76f464e0511c26c93425a9dcdc9134cf" }

version("5.3.0")      { source md5: "39b5b6a0e769716a8e0a339adc79d8ad" }

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
