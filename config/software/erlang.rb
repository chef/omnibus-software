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
default_version "R15B03-1"

dependency "zlib"
dependency "openssl"
dependency "ncurses"

source url: "http://www.erlang.org/download/otp_src_#{version}.tar.gz"

version("R15B03-1") { source md5: "eccd1e6dda6132993555e088005019f2" }
version("R16B03-1") { source md5: "e5ece977375197338c1b93b3d88514f8" }
version("R15B02")   { source md5: "ccbe5e032a2afe2390de8913bfe737a1" }
version("17.0")     { source md5: "a5f78c1cf0eb7724de3a59babc1a28e5" }
version("17.1")     { source md5: "9c90706ce70e01651adde34a2b79bf4c" }
version("17.3")     { source md5: "1d0bb2d54dfe1bb6844756b99902ba20" }
version("17.4")     { source md5: "3d33c4c6bd7950240dcd7479edd9c7d8" }
version("17.5")     { source md5: "346dd0136bf1cc28cebc140e505206bb" }
version("18.1")     { source md5: "fa64015fdd133e155b5b19bf90ac8678" }
version("18.2")     { source md5: "b336d2a8ccfbe60266f71d102e99f7ed" }

relative_path "otp_src_#{version.split('-')[0]}"

build do
  env = with_standard_compiler_flags(with_embedded_path).merge(
    # WARNING!
    "CFLAGS"  => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/erlang/include",
    "LDFLAGS" => "-Wl,-rpath #{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/erlang/include",
  )
  env.delete("CPPFLAGS")

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

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --enable-threads" \
          " --enable-smp-support" \
          " --enable-kernel-poll" \
          " --enable-dynamic-ssl-lib" \
          " --enable-shared-zlib" \
          " --enable-hipe" \
          " --without-javac" \
          " --with-ssl=#{install_dir}/embedded" \
          " --disable-debug", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
