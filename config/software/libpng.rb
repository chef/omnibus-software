#
# Copyright:: Copyright (c) 2012-2014 Chef Software, Inc.
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

name "libpng"
default_version "1.5.17"

dependency "zlib"

version "1.5.17" do
  source sha256: "f37ea62cb79713ac327c0f2555160dddc547afdf1fd052e7f648f1bac0819470"
end

version "1.5.13" do
  source sha256: "0d4c82717aef11510902908d86d78b75ad76661e87295291baa34289c5187035"
end

source url: "https://downloads.sourceforge.net/libpng/libpng-#{version}.tar.gz"
relative_path "libpng-#{version}"

configure_env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
}

build do
  command "./configure --prefix=#{install_dir}/embedded --with-zlib-prefix=#{install_dir}/embedded", env: configure_env
  command "make -j #{workers}", env: { "LD_RUN_PATH" => "#{install_dir}/embedded/lib" }
  command "make install"
end
