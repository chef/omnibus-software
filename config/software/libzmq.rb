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

license "LGPL-3.0"
license_file "COPYING"
license_file "COPYING.LESSER"

# Depend on the msys2/mingw environment given to us and don't build our
# own build tools on windows.
unless windows?
  dependency "autoconf"
  dependency "automake"
  dependency "libtool"
end

version "2.2.0" do
  source md5: "1b11aae09b19d18276d0717b2ea288f6"
  dependency "libuuid"
end
version "2.1.11" do
  source md5: "f0f9fd62acb1f0869d7aa80379b1f6b7"
  dependency "libuuid"
end

version "4.1.4" do
  source md5: "a611ecc93fffeb6d058c0e6edf4ad4fb"
  dependency "libsodium"
end
# Last stable version for "4.0.x"
version "4.0.7" do
  source md5: "9b46f7e7b0704b83638ef0d461fd59ab"
  dependency "libsodium"
end
version "4.0.5" do
  source md5: "73c39f5eb01b9d7eaf74a5d899f1d03d"
  dependency "libsodium"
end
version "4.0.4" do
  source md5: "f3c3defbb5ef6cc000ca65e529fdab3b"
  dependency "libsodium"
end

relative_path "zeromq-#{version}"
source url: "http://download.zeromq.org/zeromq-#{version}.tar.gz"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # centos 5 has an old version of gcc (4.2.1) that has trouble with
  # long long and c++ in pedantic mode
  # This patch is specific to zeromq4
  if version.satisfies?(">= 4")
    patch source: "zeromq-4.0.5_configure-pedantic_centos_5.patch", env: env if el?
  end

  # Some test files use inet_pton which is not readily available on windows.
  if version.satisfies?(">= 4") && version.satisfies?("< 4.1") && windows?
    patch source: "zeromq-4.0.11_mingw_inet_pton.patch", env: env
  end

  command("./autogen.sh", env: env, in_msys_bash: true)
  config_command = [
    "--with-libsodium",
    "--without-documentation",
    "--disable-dependency-tracking",
  ]
  configure(*config_command, env: env)

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
