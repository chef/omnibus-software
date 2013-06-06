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

name "libiconv"
version "1.14"

dependency "libgcc"

source :url => 'http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz',
       :md5 => 'e34509b1623cec449dfeb73d7ce9c6c6'

relative_path "libiconv-1.14"

env = case platform
      when "aix"
        {
          "LDFLAGS" => "-Wl,-blibpath:#{install_dir}/embedded/lib:/usr/lib:/lib -L#{install_dir}/embedded/lib",
          "CFLAGS" => "-I#{install_dir}/embedded/include"
        }
      else
        {
          "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
          "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
        }
      end

if platform == "solaris2"
  env.merge!({"LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc", "LD_OPTIONS" => "-R#{install_dir}/embedded/lib"})
end

def glibc_dropped_gets?
  return false unless OHAI["os"] == "linux"

  output = `/usr/bin/env getconf GNU_LIBC_VERSION`

  return false unless output =~ /^glibc/

  output.sub(/glibc /, "").to_f >= 2.16
end

build do
  patch :source => 'libiconv-1.14_srclib_stdio.in.h-remove-gets-declarations.patch' if glibc_dropped_gets?
  command "./configure --prefix=#{install_dir}/embedded", :env => env
  command "make -j #{max_build_jobs}", :env => env
  command "make install-lib libdir=#{install_dir}/embedded/lib includedir=#{install_dir}/embedded/include", :env => env
end
