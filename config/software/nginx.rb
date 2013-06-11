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

name "nginx"
version "1.2.3"

dependency "pcre"

source :url => "http://nginx.org/download/nginx-1.2.3.tar.gz",
       :md5 => "0a986e60826d9e3b453dbefc36bf8f6c"

relative_path "nginx-1.2.3"

build do
  command ["./configure",
           "--prefix=#{install_dir}/embedded",
           "--with-http_ssl_module",
           "--with-http_stub_status_module",
           "--with-debug",
           "--with-ld-opt=-L#{install_dir}/embedded/lib",
           "--with-cc-opt=\"-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include\""].join(" ")
  command "make -j #{max_build_jobs}", :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
  command "make install"
end
