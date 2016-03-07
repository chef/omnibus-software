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

name "autoconf"
default_version "2.68"

dependency 'm4'

source url: "https://ftp.gnu.org/gnu/autoconf/autoconf-#{version}.tar.gz"

version('2.69') { source md5: '82d05e03b93e45f5a39b828dc9c6c29b' }
version('2.68') { source md5: 'c3b5247592ce694f7097873aa07d66fe' }

relative_path "autoconf-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  if solaris2?
    env['M4'] = "#{install_dir}/embedded/bin/m4"
  end

  command "./configure" \
          " --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
