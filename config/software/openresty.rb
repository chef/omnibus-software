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
default_version "1.4.3.6"

dependency "pcre"
dependency "openssl"
dependency "zlib"

source url: "http://openresty.org/download/ngx_openresty-#{version}.tar.gz",
       md5: "5e5359ae3f1b8db4046b358d84fabbc8"

relative_path "ngx_openresty-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  if version == "1.4.3.6" && (ppc64? || ppc64le?)
    # Add necessary paths so that lua build can pick up libedit
    env['CHEF_CFLAGS'] = '-I/opt/opscode/embedded/include'
    env['CHEF_LDFLAGS'] = '-L/opt/opscode/embedded/lib'
    patch source: "v1.4.3.6.ppc64le-configure.patch", plevel: 1
  end

  # For ppc64 we use lua interpreter as luajit is not yet supported.
  lua_opts = (ppc64? || ppc64le?) ? [] : ['--with-luajit']

  command [
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
  ].concat(lua_opts).join(" "), env: env

  make "-j #{workers}", env: env
  make "install", env: env

  touch "/opt/opscode/embedded/nginx/logs/.gitkeep"
end
