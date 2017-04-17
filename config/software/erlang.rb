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

name "erlang"
default_version "18.3"

license "Apache-2.0"
license_file "LICENSE.txt"
skip_transitive_dependency_licensing true

dependency "zlib"
dependency "openssl"
dependency "ncurses"
dependency "config_guess"

source url: "http://www.erlang.org/download/otp_src_#{version}.tar.gz"

version "R15B03-1" do
  source md5:   "eccd1e6dda6132993555e088005019f2"
  relative_path "otp_src_R15B03"
  license "Erlang-Public"
  license_file "EPLICENCE"
end

version "R16B03-1" do
  source md5:   "e5ece977375197338c1b93b3d88514f8"
  relative_path "otp_src_#{version}"
  license "Erlang-Public"
  license_file "EPLICENCE"
end

version "R15B02" do
  source md5:   "ccbe5e032a2afe2390de8913bfe737a1"
  relative_path "otp_src_#{version}"
  license "Erlang-Public"
  license_file "EPLICENCE"
end

version "17.0" do
  source md5: "a5f78c1cf0eb7724de3a59babc1a28e5"
  relative_path "otp_src_17.0"
  license "Erlang-Public"
  license_file "EPLICENCE"
end

version "17.1" do
  source md5: "9c90706ce70e01651adde34a2b79bf4c"
  relative_path "otp_src_17.1"
  license "Erlang-Public"
  license_file "EPLICENCE"
end

version "17.3" do
  source md5: "1d0bb2d54dfe1bb6844756b99902ba20"
  relative_path "otp_src_17.3"
  license "Erlang-Public"
  license_file "EPLICENCE"
end

version "17.4" do
  source md5: "3d33c4c6bd7950240dcd7479edd9c7d8"
  relative_path "otp_src_17.4"
  license "Erlang-Public"
  license_file "EPLICENCE"
end

version "17.5" do
  source md5: "346dd0136bf1cc28cebc140e505206bb"
  relative_path "otp_src_17.5"
  license "Erlang-Public"
  license_file "EPLICENCE"
end

version "18.1" do
  source md5: "fa64015fdd133e155b5b19bf90ac8678"
  relative_path "otp_src_18.1"
end

version "18.2" do
  source md5: "b336d2a8ccfbe60266f71d102e99f7ed"
  relative_path "otp_src_18.2"
end

version "18.3" do
  source md5: "7e4ff32f97c36fb3dab736f8d481830b"
  relative_path "otp_src_18.3"
end

version '18.2' do
  source md5: 'b336d2a8ccfbe60266f71d102e99f7ed'
  relative_path 'otp_src_18.2'
end

build do
  env = with_standard_compiler_flags(with_embedded_path).merge(
    # WARNING!
    "CFLAGS"  => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/erlang/include",
    "LDFLAGS" => "-Wl,-rpath #{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/erlang/include"
  )
  env.delete("CPPFLAGS")

  update_config_guess(target: "erts/autoconf")
  update_config_guess(target: "lib/common_test/priv/auxdir")
  update_config_guess(target: "lib/erl_interface/src/auxdir")
  update_config_guess(target: "lib/wx/autoconf")
  update_config_guess(target: "lib/test_server/src")

  # Setup the erlang include dir
  mkdir "#{install_dir}/embedded/erlang/include"

  # At this time, erlang does not expose a way to specify the path(s) to these
  # libraries, but it looks in its local +include+ directory as part of the
  # search, so we will symlink them here so they are picked up.
  #
  # In future releases of erlang, someone should check if these flags (or
  # environment variables) are avaiable to remove this ugly hack.
  %w{ncurses openssl zlib.h zconf.h}.each do |name|
    link "#{install_dir}/embedded/include/#{name}", "#{install_dir}/embedded/erlang/include/#{name}"
  end

  # Note 2017-02-28 sr: HiPE doesn't compile with OTP 18.3 on ppc64le (https://bugs.erlang.org/browse/ERL-369)
  # Compiling fails when linking beam.smp, with
  #     powerpc64le-linux-gnu/libutil.so: error adding symbols: File in wrong format
  #
  # We've been having issues with ppc64le and hipe before, too:
  # https://github.com/chef/chef-server/commit/4fa25ed695acaf819b11f71c6db1aab5c8adcaee
  #
  # It's trying to compile using a linker script for ppc64, it seems:
  # https://github.com/erlang/otp/blob/c1ea854fac3d8ed14/erts/emulator/hipe/elf64ppc.x
  # Probably introduced with https://github.com/erlang/otp/commit/37d63e9b8a0a96
  # See also https://sourceware.org/ml/binutils/2015-05/msg00148.html
  hipe = ppc64le? ? "disable" : "enable"

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --enable-threads" \
          " --enable-smp-support" \
          " --enable-kernel-poll" \
          " --enable-dynamic-ssl-lib" \
          " --enable-shared-zlib" \
          " --#{hipe}-hipe" \
          " --without-wx" \
          " --without-megaco" \
          " --without-javac" \
          " --with-ssl=#{install_dir}/embedded" \
          " --disable-debug", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
