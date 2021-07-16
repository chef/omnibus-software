#
# Copyright:: Chef Software, Inc.
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
default_version "7.77.0"

dependency "zlib"
dependency "openssl"
dependency "cacerts"

license "MIT"
license_file "COPYING"
skip_transitive_dependency_licensing true

# version_list: url=https://curl.se/download/ filter=*.tar.gz
version("7.77.0") { source sha256: "b0a3428acb60fa59044c4d0baae4e4fc09ae9af1d8a3aa84b2e3fbcd99841f77" }
version("7.76.1") { source sha256: "5f85c4d891ccb14d6c3c701da3010c91c6570c3419391d485d95235253d837d7" }
version("7.76.0") { source sha256: "3b4378156ba09e224008e81dcce854b7ce4d182b1f9cfb97fe5ed9e9c18c6bd3" }
version("7.75.0") { source sha256: "4d51346fe621624c3e4b9f86a8fd6f122a143820e17889f59c18f245d2d8e7a6" }
version("7.74.0") { source sha256: "e56b3921eeb7a2951959c02db0912b5fcd5fdba5aca071da819e1accf338bbd7" }
version("7.73.0") { source sha256: "ba98332752257b47b9dea6d8c0ad25ec1745c20424f1dd3ff2c99ab59e97cf91" }
version("7.71.1") { source sha256: "59ef1f73070de67b87032c72ee6037cedae71dcb1d7ef2d7f59487704aec069d" }
version("7.68.0") { source sha256: "1dd7604e418b0b9a9077f62f763f6684c1b092a7bc17e3f354b8ad5c964d7358" }
version("7.65.1") { source sha256: "821aeb78421375f70e55381c9ad2474bf279fc454b791b7e95fc83562951c690" }
version("7.65.0") { source sha256: "2a65f4f858a1fa949c79f926ddc2204c2be353ccbad014e95cd322d4a87d82ad" }

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
    patch_env["PATH"] = "/opt/freeware/bin:#{env["PATH"]}" if aix?
    patch source: "curl-aix-disable-alpn.patch", plevel: 0, env: patch_env

    # otherwise gawk will die during ./configure with variations on the theme of:
    # "/opt/omnibus-toolchain/embedded/lib/libiconv.a(shr4.o) could not be loaded"
    env["LIBPATH"] = "/usr/lib:/lib"
  elsif solaris2?
    # Without /usr/gnu/bin first in PATH the libtool fails during make on Solaris
    env["PATH"] = "/usr/gnu/bin:#{env["PATH"]}"
  end

  configure_options = [
    "--prefix=#{install_dir}/embedded",
    "--disable-option-checking",
    "--disable-manual",
    "--disable-debug",
    "--enable-optimize",
    "--disable-ldap",
    "--disable-ldaps",
    "--disable-rtsp",
    "--enable-proxy",
    "--disable-pop3",
    "--disable-imap",
    "--disable-smtp",
    "--disable-gopher",
    "--disable-dependency-tracking",
    "--enable-ipv6",
    "--without-libidn2",
    "--without-gnutls",
    "--without-librtmp",
    "--without-zsh-functions-dir",
    "--without-fish-functions-dir",
    "--disable-mqtt",
    "--with-ssl=#{install_dir}/embedded",
    "--with-zlib=#{install_dir}/embedded",
    "--with-ca-bundle=#{install_dir}/embedded/ssl/certs/cacert.pem",
    "--without-zstd",
  ]

  configure(*configure_options, env: env)

  make "-j #{workers}", env: env
  make "install", env: env
end
