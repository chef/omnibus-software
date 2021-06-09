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

name "openresty"
license "BSD-2-Clause"
license_file "README.markdown"
skip_transitive_dependency_licensing true
default_version "1.19.3.2"

dependency "pcre"
dependency "openssl"
dependency "zlib"
dependency "lua" if ppc64? || ppc64le? || s390x?

source_package_name = "openresty"

# Versions above 1.11.2.2 require SSE4.2 CPU support
# versions_list: https://openresty.org/download/ filter=*.tar.gz
version("1.19.3.2") { source sha256: "ce40e764990fbbeb782e496eb63e214bf19b6f301a453d13f70c4f363d1e5bb9" }
version("1.19.3.1") { source sha256: "f36fcd9c51f4f9eb8aaab8c7f9e21018d5ce97694315b19cacd6ccf53ab03d5d" }
version("1.17.8.2") { source sha256: "2f321ab11cb228117c840168f37094ee97f8f0316eac413766305409c7e023a0" }
version("1.15.8.1") { source sha256: "89a1238ca177692d6903c0adbea5bdf2a0b82c383662a73c03ebf5ef9f570842" }
version("1.13.6.2") { source sha256: "946e1958273032db43833982e2cec0766154a9b5cb8e67868944113208ff2942" }
version("1.11.2.5") { source sha256: "f8cc203e8c0fcd69676f65506a3417097fc445f57820aa8e92d7888d8ad657b9" }
version("1.11.2.2") { source sha256: "7f9ca62cfa1e4aedf29df9169aed0395fd1b90de254139996e554367db4d5a01" }
version("1.11.2.1") { source sha256: "0e55b52bf6d77ac2d499ae2b05055f421acde6bb937e650ed8f482d11cbeeb5c" }

source url: "https://openresty.org/download/#{source_package_name}-#{version}.tar.gz"

relative_path "#{source_package_name}-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env["PATH"] += "#{env["PATH"]}:/usr/sbin:/sbin"

  if version == "1.7.10.1" && (ppc64? || ppc64le? || s390x?)
    patch source: "v1.7.10.1.ppc64le-configure.patch", plevel: 1
  end

  configure = [
    "./configure",
    "--prefix=#{install_dir}/embedded",
    "--sbin-path=#{install_dir}/embedded/sbin/nginx",
    "--conf-path=#{install_dir}/embedded/conf/nginx.conf",
    "--with-http_ssl_module",
    "--with-debug",
    "--with-http_stub_status_module",
    # Building Nginx with non-system OpenSSL
    # http://www.ruby-forum.com/topic/207287#902308
    "--with-ld-opt=\"-L#{install_dir}/embedded/lib -Wl,-rpath,#{install_dir}/embedded/lib -lssl -lcrypto -ldl -lz\"",
    "--with-cc-opt=\"-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include\"",
    # Options inspired by the OpenResty Cookbook
    "--with-md5-asm",
    "--with-sha1-asm",
    "--with-pcre-jit",
    "--without-http_ssi_module",
    "--without-mail_smtp_module",
    "--without-mail_imap_module",
    "--without-mail_pop3_module",
    "--with-ipv6",
    # AIO support define in Openresty cookbook. Requires Kernel >= 2.6.22
    # Ubuntu 10.04 reports: 2.6.32-38-server #83-Ubuntu SMP
    # However, they require libatomic-ops-dev and libaio
    # '--with-file-aio',
    # '--with-libatomic'
  ]

  # HTTP/2 was introduced with nginx 1.9.5
  if version.satisfies?(">= 1.9.5")
    configure << "--with-http_v2_module"
  end

  # Currently LuaJIT doesn't support POWER correctly so use Lua51 there instead
  if ppc64? || ppc64le? || s390x?
    # 1.13 breaks these; discover a workaround
    if version.satisfies?(">= 1.13")
      exit("ppc64? || ppc64le? || s390x? unsupported for 1.13 and greater")
    else
      configure << "--with-lua51=#{install_dir}/embedded/lib"
    end
  else
    configure << "--with-luajit"
  end

  command configure.join(" "), env: env

  make "-j #{workers}", env: env
  make "install", env: env

  touch "#{install_dir}/embedded/nginx/logs/.gitkeep"
end
