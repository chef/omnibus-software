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

name "libtool"
version "2.4"

source :url => "http://ftp.gnu.org/gnu/libtool/libtool-2.4.tar.gz",
       :md5 => "b32b04148ecdd7344abc6fe8bd1bb021"

relative_path "libtool-2.4"

build do
  env = case platform
        when "aix"
        {
            "LDFLAGS" => "-L#{install_dir}/embedded/lib -Wl,-blibpath:#{install_dir}/embedded/lib:/usr/lib:/lib",
            "CFLAGS" => "-maix64 -O -I#{install_dir}/embedded/include",
            "OBJECT_MODE" => "64",
            "CC" => "gcc -maix64",
            "CXX" => "g++ -maix64",
        }
  end
  if platform == "aix"
    command "./configure --prefix=#{install_dir}/embedded --with-gcc", :env => env
    command "make", :env => env
  else
    command "./configure --prefix=#{install_dir}/embedded"
    command "make"
  end
  command "make install"
end
