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

name "erlang"
default_version "24.1.7"

license "Apache-2.0"
license_file "LICENSE.txt"
skip_transitive_dependency_licensing true

dependency "zlib"
dependency "openssl"
dependency "ncurses"
dependency "config_guess"

# grab from github so we can get patch releases if we need to
source url: "https://github.com/erlang/otp/archive/OTP-#{version}.tar.gz"
relative_path "otp-OTP-#{version}"

# versions_list: https://github.com/erlang/otp/tags filter=*.tar.gz

version("24.1.7")    { source sha256: "a1dd1a238f1f3e79784b902f3cd00e06f35a630191eaf73324a07a26a2c93af3" }
version("24.1.3")    { source sha256: "7ccfa8372995fc7895baeb3729f679aff87781d1b7c734acd22740bc41ee2eed" }
version("22.2.8")    { source sha256: "71f73ddd59db521928a0f6c8d4354d6f4e9f4bfbd0b40d321cd5253a6c79b095" }
version("22.2")      { source sha256: "232c37a502c7e491a9cbf86acb7af64fbc1a793fcbcbd0093cb029cf1c3830a7" }
version("18.3")      { source sha256: "a6d08eb7df06e749ccaf3049b33ceae617a3c466c6a640ee8d248c2372d48f4e" }

build do
  # Don't listen on 127.0.0.1/::1 implicitly whenever ERL_EPMD_ADDRESS is given
  patch source: "epmd-require-explicitly-adding-loopback-address.patch", plevel: 1

  env = with_standard_compiler_flags(with_embedded_path).merge(
    # WARNING!
    "CFLAGS"  => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/erlang/include",
    "LDFLAGS" => "-Wl,-rpath #{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/erlang/include"
  )
  env.delete("CPPFLAGS")

  # The TYPE env var sets the type of emulator you want
  # We want the default so we give TYPE and empty value
  # in case it was set by CI.
  env["TYPE"] = ""

  update_config_guess(target: "erts/autoconf")
  update_config_guess(target: "lib/common_test/priv/auxdir")
  update_config_guess(target: "lib/erl_interface/src/auxdir")
  update_config_guess(target: "lib/wx/autoconf")

  if version.satisfies?(">= 19.0")
    update_config_guess(target: "lib/common_test/test_server/src")
  else
    update_config_guess(target: "lib/test_server/src")
  end

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

  unless File.exist?("./configure")
    # Building from github source requires this step
    command "./otp_build autoconf"
  end
  # Note: et, debugger and observer applications require wx to
  # build. The tarballs from the downloads site has prebuilt the beam
  # files, so we were able to get away without disabling them and
  # still build. When building from raw source we must disable them
  # explicitly.
  wx = "without"

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --enable-threads" \
          " --enable-smp-support" \
          " --enable-kernel-poll" \
          " --enable-dynamic-ssl-lib" \
          " --enable-shared-zlib" \
          " --enable-fips" \
          " --#{hipe}-hipe" \
          " --#{wx}-wx" \
          " --#{wx}-et" \
          " --#{wx}-debugger" \
          " --#{wx}-observer" \
          " --without-megaco" \
          " --without-javac" \
          " --with-ssl=#{install_dir}/embedded" \
          " --disable-debug", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
