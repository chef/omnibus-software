#
# Copyright 2012-2014 Chef Software, Inc.omnibus
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
default_version "1.14"

dependency "libgcc"

source url: "http://ftp.gnu.org/pub/gnu/libiconv/libiconv-#{version}.tar.gz",
       md5: 'e34509b1623cec449dfeb73d7ce9c6c6'

relative_path "libiconv-#{version}"

build do
  env = with_standard_compiler_flags

  patch source: 'libiconv-1.14_srclib_stdio.in.h-remove-gets-declarations.patch'

  command "./configure --prefix=#{install_dir}/embedded", env: env

  command "make -j #{max_build_jobs}", env: env
  command "make -j #{max_build_jobs} install-lib libdir=#{install_dir}/embedded/lib includedir=#{install_dir}/embedded/include", env: env
end
