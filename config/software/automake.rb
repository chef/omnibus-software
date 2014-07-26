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

name "automake"
default_version "1.11.2"

dependency "autoconf"

source url: "http://ftp.gnu.org/gnu/automake/automake-#{version}.tar.gz",
       md5: "79ad64a9f6e83ea98d6964cef8d8a0bc"

relative_path "automake-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./bootstrap", env: env
  command "./configure" \
          " --prefix=#{install_dir}/embedded", env: env

  command "make -j #{max_build_jobs}", env: env
  command "make install", env: env
end
