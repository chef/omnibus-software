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

dependency "zlib"
dependency "cacerts"
dependency "libgcc"


if platform == "aix"
  # XXX: OpenSSL has an open bug on 1.0.1e where it fails to install on AIX
  #      http://rt.openssl.org/Ticket/Display.html?id=2986&user=guest&pass=guest
  version "1.0.1c"
  source :url => "http://www.openssl.org/source/openssl-1.0.1c.tar.gz",
         :md5 => "ae412727c8c15b67880aef7bd2999b2e"
else
  version "1.0.1e"
  source :url => "http://www.openssl.org/source/openssl-1.0.1e.tar.gz",
         :md5 => "66bf6f10f060d561929de96f9dfe5b8c"
end

relative_path "openssl-#{version}"

build do
  env = case platform
        when "mac_os_x"
          {
            "CFLAGS" => "-arch x86_64 -m64 -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -I#{install_dir}/embedded/include/ncurses",
            "LDFLAGS" => "-arch x86_64 -R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -I#{install_dir}/embedded/include/ncurses"
          }
        when "aix"
        {
            "LDFLAGS" => "-bsvr4 -Wl,-blibpath:#{install_dir}/embedded/lib:/usr/lib:/lib -L#{install_dir}/embedded/lib",
            "CFLAGS" => "-I#{install_dir}/embedded/include",
            "AR" => "/usr/bin/ar",
            "CC" => "xlc",
            "CXX" => "xlC"
        }
        when "solaris2"
          {
            "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
            "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc",
            "LD_OPTIONS" => "-R#{install_dir}/embedded/lib"
          }
        else
          {
            "CFLAGS" => "-I#{install_dir}/embedded/include",
            "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib"
          }
        end

  common_args = [
    "--prefix=#{install_dir}/embedded",
    "--with-zlib-lib=#{install_dir}/embedded/lib",
    "--with-zlib-include=#{install_dir}/embedded/include",
    "no-idea",
    "no-mdc2",
    "no-rc5",
    "zlib",
    "shared",
  ].join(" ")

  configure_command = case platform
                      when "aix"
                        ["perl", "./Configure",
                         "aix-cc",
                         common_args,
                        "-L#{install_dir}/embedded/lib",
                        "-I#{install_dir}/embedded/include",
                        "-Wl,-bsvr4",
                        "-Wl,-R#{install_dir}/embedded/lib"].join(" ")
                      when "mac_os_x"
                        ["./Configure",
                         "darwin64-x86_64-cc",
                         common_args,
                        ].join(" ")
                      when "smartos"
                        ["/bin/bash ./Configure",
                         "solaris64-x86_64-gcc",
                         common_args,
                         "-L#{install_dir}/embedded/lib",
                         "-I#{install_dir}/embedded/include",
                         "-R#{install_dir}/embedded/lib",
                        "-static-libgcc"].join(" ")
                      when "solaris2"
                        if Omnibus.config.solaris_compiler == "gcc"
                          if architecture == "sparc"
                            ["/bin/sh ./Configure",
                             "solaris-sparcv9-gcc",
                             common_args,
                            "-L#{install_dir}/embedded/lib",
                            "-I#{install_dir}/embedded/include",
                            "-R#{install_dir}/embedded/lib",
                            "-static-libgcc"].join(" ")
                          else
                            # This should not require a /bin/sh, but without it we get
                            # Errno::ENOEXEC: Exec format error
                            ["/bin/sh ./Configure",
                             "solaris-x86-gcc",
                             common_args,
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
                        common_args,
                        "disable-gost",  # fixes build on linux, but breaks solaris
                        "-L#{install_dir}/embedded/lib",
                        "-I#{install_dir}/embedded/include",
                        "-Wl,-rpath,#{install_dir}/embedded/lib"].join(" ")
                      end

  # @todo: move into omnibus-ruby
  has_gmake = system("gmake --version")

  if has_gmake
    env.merge!({'MAKE' => 'gmake'})
    make_binary = 'gmake'
  else
    make_binary = 'make'
  end

  command configure_command, :env => env
  # make -jN is busted on openssl (http://comments.gmane.org/gmane.comp.encryption.openssl.devel/22800)
  command "#{make_binary} -j 1", :env => env
  command "#{make_binary} install", :env => env
end
