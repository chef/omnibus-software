#
# Copyright:: Copyright (c) 2013 Robby Dyer
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
name "libevent"
version "2.0.21"

dependency "openssl"

source :url => "https://github.com/downloads/libevent/libevent/libevent-#{version}-stable.tar.gz",
       :md5 => "b2405cc9ebf264aa47ff615d9de527a2"

relative_path "libevent-#{version}-stable"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
  "LD_LIBRARY_PATH" => "#{install_dir}/embedded/lib",
}

build do
  command [
            "./configure",
            "--prefix=#{install_dir}/embedded",
           ].join(" "), :env => env
  command "make -j #{max_build_jobs}", :env => env
  command "make install", :env => env
end
