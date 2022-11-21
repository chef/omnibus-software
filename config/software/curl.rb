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
default_version "7.84.0"

dependency "zlib"
dependency "openssl"
dependency "cacerts"

license "MIT"
license_file "COPYING"
skip_transitive_dependency_licensing true

# version_list: url=https://curl.se/download/ filter=*.tar.gz
version("7.85.0") { source sha256: "78a06f918bd5fde3c4573ef4f9806f56372b32ec1829c9ec474799eeee641c27" }
version("7.84.0") { source sha256: "3c6893d38d054d4e378267166858698899e9d87258e8ff1419d020c395384535" }
version("7.83.1") { source sha256: "93fb2cd4b880656b4e8589c912a9fd092750166d555166370247f09d18f5d0c0" }
version("7.82.0") { source sha256: "910cc5fe279dc36e2cca534172c94364cf3fcf7d6494ba56e6c61a390881ddce" }
version("7.81.0") { source sha256: "ac8e1087711084548d788ef18b9b732c8de887457b81f616fc681d1044b32f98" }
version("7.80.0") { source sha256: "dab997c9b08cb4a636a03f2f7f985eaba33279c1c52692430018fae4a4878dc7" }
version("7.79.1") { source sha256: "370b11201349816287fb0ccc995e420277fbfcaf76206e309b3f60f0eda090c2" }

source url: "https://curl.haxx.se/download/curl-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

relative_path "curl-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  if freebsd? && version.satisfies?("< 7.82.0")
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
    "--without-brotli",
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
