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

name "openresty"
default_version "1.9.3.1"

dependency "pcre"
dependency "openssl"
dependency "zlib"

version("1.9.3.1") { source md5: "cde1f7127f6ba413ee257003e49d6d0a" }
version("1.7.10.2") { source md5: "bca1744196acfb9e986f1fdbee92641e" }
version("1.7.10.1") { source md5: "1093b89459922634a818e05f80c1e18a" }
version("1.4.3.6") { source md5: "5e5359ae3f1b8db4046b358d84fabbc8" }

source url: "http://openresty.org/download/ngx_openresty-#{version}.tar.gz"

relative_path "ngx_openresty-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env['PATH'] += "#{env['PATH']}:/usr/sbin:/sbin"

  if version == "1.7.10.1" && (ppc64? || ppc64le?)
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
    '--with-md5-asm',
    '--with-sha1-asm',
    '--with-pcre-jit',
    '--without-http_ssi_module',
    '--without-mail_smtp_module',
    '--without-mail_imap_module',
    '--without-mail_pop3_module',
    '--with-ipv6',
    # AIO support define in Openresty cookbook. Requires Kernel >= 2.6.22
    # Ubuntu 10.04 reports: 2.6.32-38-server #83-Ubuntu SMP
    # However, they require libatomic-ops-dev and libaio
    #'--with-file-aio',
    #'--with-libatomic'
  ]

  # Currently LuaJIT doesn't support POWER correctly so use Lua51 there instead
  if (ppc64? || ppc64le?)
    configure << '--with-lua51'
  else
    configure << '--with-luajit'
  end

  # OpenResty 1.7 + RHEL5 Fixes:
  # According to https://github.com/openresty/ngx_openresty/issues/85, OpenResty
  # fails to compile on RHEL5 without the "--with-luajit-xcflags='-std=gnu99'" flags
  if rhel? &&
     platform_version.satisfies?('< 6.0') &&
     version.satisfies?('>= 1.7')
    configure << "--with-luajit-xcflags='-std=gnu99'"
  end

  command configure.join(" "), env: env

  make "-j #{workers}", env: env
  make "install", env: env

  touch "/opt/opscode/embedded/nginx/logs/.gitkeep"
end
