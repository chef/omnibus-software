#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
# License:: Apache License, Version 2.0
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
version "R15B02"

dependency "zlib"
dependency "openssl"
dependency "ncurses"

source :url => "http://www.erlang.org/download/otp_src_R15B02.tar.gz",
       :md5 => "ccbe5e032a2afe2390de8913bfe737a1"

relative_path "otp_src_R15B02"

env = {
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/erlang/include",
  "LDFLAGS" => "-Wl,-rpath #{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/erlang/include"
}

build do
  # set up the erlang include dir
  command "mkdir -p #{install_dir}/embedded/erlang/include"
  %w{ncurses openssl zlib.h zconf.h}.each do |link|
    command "ln -fs #{install_dir}/embedded/include/#{link} #{install_dir}/embedded/erlang/include/#{link}"
  end

  # TODO: build cross-platform. this is for linux
  command(["./configure",
           "--prefix=#{install_dir}/embedded",
           "--enable-threads",
           "--enable-smp-support",
           "--enable-kernel-poll",
           "--enable-dynamic-ssl-lib",
           "--enable-shared-zlib",
           "--enable-hipe",
           "--without-javac",
           "--with-ssl=#{install_dir}/embedded",
           "--disable-debug"].join(" "),
          :env => env)

  command "make", :env => env
  command "make install"
end
