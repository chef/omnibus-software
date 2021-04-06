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
# expeditor/ignore: deprecated 2021-04

name "keepalived"
default_version "1.2.9"

license "GPL-2.0"
license_file "COPYING"
skip_transitive_dependency_licensing true

dependency "popt"
dependency "openssl"

source url: "http://www.keepalived.org/software/keepalived-#{version}.tar.gz"

version "1.2.19" do
  source md5: "5c98b06639dd50a6bff76901b53febb6"
end

version "1.2.9" do
  source md5: "adfad98a2cc34230867d794ebc633492"
end

version "1.1.20" do
  source md5: "6c3065c94bb9e2187c4b5a80f6d8be31"
end

relative_path "keepalived-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # This is cherry-picked from change
  # d384ce8b3492b9d76af23e621a20bed8da9c6016 of keepalived, (master
  # branch), and should be no longer necessary after 1.2.9.
  if version == "1.2.9"
    patch source: "keepalived-1.2.9_opscode_centos_5.patch", env: env
  end

  configure = [
    "./configure",
    "--prefix=#{install_dir}/embedded",
    " --disable-iconv",
  ]

  if suse?
    configure << "--with-kernel-dir=/usr/src/linux/include/uapi"
  end

  command configure.join(" "), env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
