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

name "fcgiwrap"
default_version "1.0.3"

dependency "autoconf"
dependency "fcgi"

source git: "git://github.com/gnosek/fcgiwrap"

relative_path "fcgiwrap"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "autoreconf -i", env: env
  command "./configure --prefix=#{install_dir}/embedded", env: env

  command "make -j #{max_build_jobs}", env: env
  command "make install"
end
