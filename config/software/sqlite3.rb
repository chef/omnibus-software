#
# Copyright:: Copyright (c) 2014 Ryan Langford
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

name "sqlite3"
default_version "3080500"

version "3080500" do
  source :md5 => "0544ef6d7afd8ca797935ccc2685a9ed"
end

source :url => "http://www.sqlite.org/2014/#{name}-autoconf-#{version}.tar.gz"

relative_path "sqlite-autoconf-#{version}"

config_env = {
   "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
   "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
   "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  command "./configure --prefix=#{install_dir}/embedded --disable-readline", :env => config_env
  command "make -j #{max_build_jobs}", :env => config_env
  command "make install"
end
