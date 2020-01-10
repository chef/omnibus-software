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

name "autoconf"
default_version "2.69"

dependency "config_guess"

source url: "http://ftp.gnu.org/gnu/autoconf/autoconf-#{version}.tar.gz",
       md5: "82d05e03b93e45f5a39b828dc9c6c29b"

relative_path "autoconf-2.69"

env = {
  "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
}

build do
  update_config_guess(target: "build-aux")
  command "./configure --prefix=#{install_dir}/embedded", env: env
  command "make -j #{workers}"
  command "make install"
end
