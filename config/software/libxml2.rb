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

name "libxml2"
version "2.7.8"

dependency "zlib"
dependency "libiconv"

md5 = {
  "2.7.8" => "8127a65e8c3b08856093099b52599c86",
  "2.9.1" => "9c0cfef285d5c4a5c80d00904ddab380",
}
source :url => "ftp://xmlsoft.org/libxml2/libxml2-#{version}.tar.gz",
       :md5 => md5[version]

relative_path "libxml2-#{version}"

build do
  cmd = ["./configure",
         "--prefix=#{install_dir}/embedded",
         "--with-zlib=#{install_dir}/embedded",
         "--with-iconv=#{install_dir}/embedded",
         "--without-python",
         "--without-icu"].join(" ")
  env = {
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
  }
  command cmd, :env => env
  command "make -j #{max_build_jobs}", :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
  command "make install", :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
end
