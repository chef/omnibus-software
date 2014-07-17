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

name "gdbm"
default_version "1.9.1"

version "1.9.1" do
  source md5: "59f6e4c4193cb875964ffbe8aa384b58"
end

source url: "http://ftp.gnu.org/gnu/gdbm/gdbm-#{version}.tar.gz",

relative_path "gdbm-#{version}"

env = with_embedded_path()
env = with_standard_compiler_flags(env)

build do
  configure_command = ["./configure",
                       "--enable-libgdbm-compat",
                       "--prefix=#{install_dir}/embedded"]

  if Ohai['platform'] == "freebsd"
    configure_command << "--with-pic"
  end

  command configure_command.join(" "), env: env
  command "make -j #{max_build_jobs}", env: env
  command "make install", env: env
end
