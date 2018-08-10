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

name "curl"
default_version "7.59.0"

dependency "zlib"
dependency "openssl"
dependency "cacerts"

license "MIT"
license_file "COPYING"
skip_transitive_dependency_licensing true
version("7.59.0") { source sha256: "099d9c32dc7b8958ca592597c9fabccdf4c08cfb7c114ff1afbbc4c6f13c9e9e" }
version("7.56.0") { source sha256: "f1bc17a7e5662dbd8d4029750a6dbdb72a55cf95826a270ab388b05075526104" }
version("7.53.1") { source sha256: "64f9b7ec82372edb8eaeded0a9cfa62334d8f98abc65487da01188259392911d" }
version("7.51.0") { source sha256: "65b5216a6fbfa72f547eb7706ca5902d7400db9868269017a8888aa91d87977c" }
version("7.47.1") { source md5: "3f9d1be7bf33ca4b8c8602820525302b" }
version("7.36.0") { source md5: "643a7030b27449e76413d501d4b8eb57" }

source url: "https://curl.haxx.se/download/curl-#{version}.tar.gz"

relative_path "curl-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  if freebsd?
    # from freebsd ports - IPv6 Hostcheck patch
    patch source: "curl-freebsd-hostcheck.patch", plevel: 1, env: env
  end

  delete "#{project_dir}/src/tool_hugehelp.c"

  if aix?
    # alpn doesn't appear to work on AIX when connecting to certain sites, most
    # importantly for us https://www.github.com Since git uses libcurl under
    # the covers, this functionality breaks the handshake on connection, giving
    # a cryptic error. This patch essentially forces disabling of ALPN on AIX,
    # which is not really what we want in a http/2 world, but we're not there
    # yet.
    patch_env = env.dup
    patch_env["PATH"] = "/opt/freeware/bin:#{env['PATH']}" if aix?
    patch source: "curl-aix-disable-alpn.patch", plevel: 0, env: patch_env

    # otherwise gawk will die during ./configure with variations on the theme of:
    # "/opt/omnibus-toolchain/embedded/lib/libiconv.a(shr4.o) could not be loaded"
    env["LIBPATH"] = "/usr/lib:/lib"
  end

  configure_options = [
    "--prefix=#{install_dir}/embedded",
    "--disable-manual",
    "--disable-debug",
    "--enable-optimize",
    "--disable-ldap",
    "--disable-ldaps",
    "--disable-rtsp",
    "--enable-proxy",
    "--disable-dependency-tracking",
    "--enable-ipv6",
    "--without-libidn",
    "--without-gnutls",
    "--without-librtmp",
    "--with-ssl=#{install_dir}/embedded",
    "--with-zlib=#{install_dir}/embedded",
    "--with-ca-bundle=#{install_dir}/embedded/ssl/certs/cacert.pem",
  ]

  configure(*configure_options, env: env)

  make "-j #{workers}", env: env
  make "install", env: env
end
