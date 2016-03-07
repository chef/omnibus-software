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

name "make"
default_version "4.1"

source url: "https://ftp.gnu.org/gnu/make/make-#{version}.tar.gz"

version('4.1') { source md5: '654f9117957e6fa6a1c49a8f08270ec9' }

relative_path "make-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure" \
          " --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "install", env: env

  # We are very prescriptive. We made make, we will make all the things use it!
  link "#{install_dir}/embedded/bin/make", "#{install_dir}/embedded/bin/gmake"
end
