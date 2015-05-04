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

# We use the version in util-linux, and only build the libuuid subdirectory
name "libzmq"
default_version "2.1.11"

dependency "autoconf"
dependency "automake"
dependency "libtool"

version "2.1.11" do
  source md5: "f0f9fd62acb1f0869d7aa80379b1f6b7"
  dependency "libuuid"
end
version "4.0.4" do
  source md5: "f3c3defbb5ef6cc000ca65e529fdab3b"
  dependency "libsodium"
end
version "4.0.5" do
  source md5: "73c39f5eb01b9d7eaf74a5d899f1d03d"
  dependency "libsodium"
end

relative_path "zeromq-#{version}"
source url: "http://download.zeromq.org/zeromq-#{version}.tar.gz"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env['CXXFLAGS'] = "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"

  command "./autogen.sh", env: env
  command "./configure --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
