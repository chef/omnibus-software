#
# Copyright 2014 Chef Software, Inc.
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

name "php"
default_version "5.3.10"

dependency "zlib"
dependency "pcre"
dependency "libxslt"
dependency "libxml2"
dependency "libiconv"
dependency "openssl"
dependency "gd"

source url: "http://us.php.net/distributions/php-#{version}.tar.gz",
       md5: "2b3d2d0ff22175685978fb6a5cbcdc13"

relative_path "php-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --without-pear" \
          " --with-zlib-dir=#{install_dir}/embedded" \
          " --with-pcre-dir=#{install_dir}/embedded" \
          " --with-xsl=#{install_dir}/embedded" \
          " --with-libxml-dir=#{install_dir}/embedded" \
          " --with-iconv=#{install_dir}/embedded" \
          " --with-openssl-dir=#{install_dir}/embedded" \
          " --with-gd=#{install_dir}/embedded" \
          " --enable-fpm" \
          " --with-fpm-user=opscode" \
          " --with-fpm-group=opscode", env: env

  make "-j #{max_build_jobs}", env: env
  make "install", env: env
end
