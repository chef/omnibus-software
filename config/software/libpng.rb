#
# Copyright 2012-2014 Chef Software, Inc.
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

source url: "http://downloads.sourceforge.net/libpng/libpng-#{version}.tar.gz"

version "1.5.17" do
  source md5: "d2e27dbd8c6579d1582b3f128fd284b4"
end

version "1.5.13" do
  source md5: "9c5a584d4eb5fe40d0f1bc2090112c65"
end

relative_path "libpng-#{version}"

build do
  env = with_standard_compiler_flags

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --with-zlib-prefix=#{install_dir}/embedded", env: env

  command "make -j #{max_build_jobs}", env: env
  command "make install"
end
