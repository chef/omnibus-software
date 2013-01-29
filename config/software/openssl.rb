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

name "openssl"
version "1.0.1c"

dependency "zlib"
dependency "cacerts"

source :url => "http://www.openssl.org/source/openssl-1.0.1c.tar.gz",
       :md5 => "ae412727c8c15b67880aef7bd2999b2e"

relative_path "openssl-1.0.1c"

build do
  env = case platform
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
          when "smartos"
            {
              "CFLAGS"  => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
              "LDFLAGS" => "-L#{install_dir}/embedded/lib"
            }
        else
          {
            "CFLAGS" => "-I#{install_dir}/embedded/include",
            "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib"
          }
        end

  configure_command = case platform
                      when "mac_os_x"
                        ["./Configure",
                         "darwin64-x86_64-cc",
                         "--prefix=#{install_dir}/embedded",
                        "--with-zlib-lib=#{install_dir}/embedded/lib",
                        "--with-zlib-include=#{install_dir}/embedded/include",
                        "zlib",
                        "shared"].join(" ")
                      when "smartos"
                            ["/bin/bash ./Configure",
                             "solaris64-x86_64-gcc",
                             "--prefix=#{install_dir}/embedded",
                             "--with-zlib-lib=#{install_dir}/embedded/lib",
                             "--with-zlib-include=#{install_dir}/embedded/include",
                            "zlib",
                            "shared",
                             "-L#{install_dir}/embedded/lib",
                             "-I#{install_dir}/embedded/include",
                             "-R#{install_dir}/embedded/lib",
                            "-static-libgcc"].join(" ")
                      when "solaris2"
                        if Omnibus.config.solaris_compiler == "gcc"
                          if architecture == "sparc"
                            ["/bin/sh ./Configure",
                             "solaris-sparcv9-gcc",
                             "--prefix=#{install_dir}/embedded",
                            "--with-zlib-lib=#{install_dir}/embedded/lib",
                            "--with-zlib-include=#{install_dir}/embedded/include",
                            "zlib",
                            "shared",
                            "-L#{install_dir}/embedded/lib",
                            "-I#{install_dir}/embedded/include",
                            "-R#{install_dir}/embedded/lib",
                            "-static-libgcc"].join(" ")
                          else
                            # This should not require a /bin/sh, but without it we get
                            # Errno::ENOEXEC: Exec format error
                            ["/bin/sh ./Configure",
                             "solaris-x86-gcc",
                             "--prefix=#{install_dir}/embedded",
                            "--with-zlib-lib=#{install_dir}/embedded/lib",
                            "--with-zlib-include=#{install_dir}/embedded/include",
                            "zlib",
                            "shared",
                            "-L#{install_dir}/embedded/lib",
                            "-I#{install_dir}/embedded/include",
                            "-R#{install_dir}/embedded/lib",
                            "-static-libgcc"].join(" ")
                          end
                        else
                          raise "sorry, we don't support building openssl on non-gcc solaris builds right now."
                        end
                      else
                        ["./config",
                         "--prefix=#{install_dir}/embedded",
                        "--with-zlib-lib=#{install_dir}/embedded/lib",
                        "--with-zlib-include=#{install_dir}/embedded/include",
                        "zlib",
                        "shared",
                        "disable-gost",
                        "-L#{install_dir}/embedded/lib",
                        "-I#{install_dir}/embedded/include",
                        "-Wl,-rpath,#{install_dir}/embedded/lib"].join(" ")
                      end

  command configure_command, :env => env
  command "make", :env => env
  command "make install", :env => env

end
