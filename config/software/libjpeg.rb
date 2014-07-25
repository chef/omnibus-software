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

name "libjpeg"
default_version "8d"

source url: "http://www.ijg.org/files/jpegsrc.v8d.tar.gz",
       md5: "52654eb3b2e60c35731ea8fc87f1bd29"

relative_path "jpeg-8d"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --enable-shared " \
          " --enable-static", env: env

  mkdir "#{install_dir}/embedded/man/man1"

  command "make -j #{max_build_jobs}", env: env
  command "make install"

  delete "#{install_dir}/embedded/man"
end
