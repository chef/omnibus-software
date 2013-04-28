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
version "1.9.3-p286"

dependency "zlib"
dependency "ncurses"
dependency "libedit"
dependency "openssl"
dependency "libyaml"
dependency "libiconv"
dependency "gdbm" if OHAI.platform == "mac_os_x" or OHAI.platform == "freebsd"
dependency "libgcc" if (platform == "solaris2" and Omnibus.config.solaris_compiler == "gcc")

source :url => "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-#{version}.tar.gz",
       :md5 => 'e2469b55c2a3d0d643097d47fe4984bb'

relative_path "ruby-#{version}"

env =
  case platform
  when "mac_os_x"
    {
      "CFLAGS" => "-arch x86_64 -m64 -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -I#{install_dir}/embedded/include/ncurses",
      "LDFLAGS" => "-arch x86_64 -R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -I#{install_dir}/embedded/include/ncurses"
    }
  when "solaris2"
    if Omnibus.config.solaris_compiler == "studio"
    {
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
    }
    elsif Omnibus.config.solaris_compiler == "gcc"
    {
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc",
      "LD_OPTIONS" => "-R#{install_dir}/embedded/lib"
    }
    else
      raise "Sorry, #{Omnibus.config.solaris_compiler} is not a valid compiler selection."
    end
  when "freebsd"
    {
      "RUBYOPT" => "",
      "CFLAGS" => "-fno-omit-frame-pointer -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LD_OPTIONS" => "-R#{install_dir}/embedded/lib"
    }
  else
    {
      "CFLAGS" => "-I#{install_dir}/embedded/include",
      "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib"
    }
  end

extra_configure_args =
  case platform
  when "freebsd"
    #"--with-execinfo-dir=#{install_dir}/embedded"
    "--without-execinfo"
  else
    ""
  end

build do
  if platform == "freebsd"
    patch :source => "freebsd-libexecinfo-location.patch"
  end
  command ["./configure",
           "--prefix=#{install_dir}/embedded",
           "--with-opt-dir=#{install_dir}/embedded",
           "--with-out-ext=fiddle",
           "--enable-shared",
           "--enable-libedit",
           "--with-ext=psych",
           extra_configure_args,
           "--disable-install-doc"].join(" "), :env => env
  command "env - #{env.map{|k,v| k=[k,"'#{v}'"].join("=")}.join(" ")} PATH=$PATH make -j #{max_build_jobs}", :env => env
  command "env - #{env.map{|k,v| k=[k,"'#{v}'"].join("=")}.join(" ")} PATH=$PATH make install", :env => env

#  if (platform == "solaris2" and Omnibus.config.solaris_compiler == "gcc")
#    command "/opt/omnibus/bootstrap/bin/chrpath -r #{install_dir}/embedded/lib #{install_dir}/embedded/lib/libruby.so.1"
#  end
end
