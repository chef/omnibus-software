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

name "curl"
default_version "8.7.1"

dependency "zlib"
dependency ENV["OMNIBUS_OPENSSL_SOFTWARE"] || "openssl"
dependency "nghttp2"
source url:    "https://curl.haxx.se/download/curl-#{version}.tar.gz",
       sha256: "f91249c87f68ea00cf27c44fdfa5a78423e41e71b7d408e5901a9896d905c495"

relative_path "curl-#{version}"

build do
  license "Curl"
  license_file "https://raw.githubusercontent.com/bagder/curl/master/COPYING"
  env = with_standard_compiler_flags(with_embedded_path)

  configure_options = [
           "--disable-manual",
           "--disable-debug",
           "--enable-optimize",
           "--disable-static",
           "--disable-ldap",
           "--disable-ldaps",
           "--disable-rtsp",
           "--enable-proxy",
           "--disable-dependency-tracking",
           "--enable-ipv6",
           "--without-libidn",
           "--without-gnutls",
           "--without-librtmp",
           "--without-libssh2",
           "--with-ssl=#{install_dir}/embedded",
           "--with-zlib=#{install_dir}/embedded",
           "--with-nghttp2=#{install_dir}/embedded",
  ]
  configure(*configure_options, env: env)

  command "make -j #{workers}", env: env
  command "make install"
end
