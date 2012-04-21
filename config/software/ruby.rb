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

name "ruby"
version "1.9.2p290"

dependencies ["zlib", "ncurses", "readline", "openssl"]

source :url => 'http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p290.tar.gz',
       :md5 => '604da71839a6ae02b5b5b5e1b792d5eb'

relative_path "ruby-1.9.2-p290"

make_command =
  case platform
  when "freebsd"
    "gmake"
  else
    "make"
  end

env =
  case platform
  when "darwin"
    {
      "CFLAGS" => "-arch x86_64 -m64 -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-arch x86_64 -R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
    }
  when "solaris2"
    {
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
    }
  else
    {
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-Wl,-rpath #{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
    }
  end

build do
  # command "#{install_dir}/embedded/bin/autoconf", :env => env
  command "./configure --prefix=#{install_dir}/embedded --with-opt-dir=#{install_dir}/embedded --enable-shared --disable-install-doc --with-out-ext=fiddle,gdbm,psych", :env => env
  command "#{make_command} -j #{max_build_jobs}"
  command "#{make_command} install"
end
