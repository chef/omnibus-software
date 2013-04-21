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

name "keepalived"
version "1.1.20"

dependency "popt"

source :url => "http://www.keepalived.org/software/keepalived-1.1.20.tar.gz",
       :md5 => "6c3065c94bb9e2187c4b5a80f6d8be31"

relative_path "keepalived-1.1.20"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  patch :source => "keepalived-1.1.20_opscode_unicast.patch"
  patch :source => "keepalived-1.1.20_opscode_missing_ntohl.patch"
  command "./configure --prefix=#{install_dir}/embedded --disable-iconv", :env => env
  command "make -j #{max_build_jobs}", :env => env
  command "make install"
end


