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

name "automake"
default_version "1.11.2"

dependency "autoconf"
dependency "config_guess"

source url: "https://ftp.gnu.org/gnu/automake/automake-1.11.2.tar.gz",
       sha256: "c339e3871d6595620760725da61de02cf1c293af8a05b14592d6587ac39ce546"

relative_path "automake-1.11.2"

configure_env = {
  "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}",
}

build do
  update_config_guess(target: "lib")
  command "./bootstrap", env: { "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}" }
  command "./configure --prefix=#{install_dir}/embedded", env: configure_env
  command "make -j #{workers}"
  command "make install"
end
