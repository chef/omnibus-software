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

name "nagios-plugins"
default_version "1.4.15"

dependency "zlib"
dependency "openssl"
dependency "postgresql"
dependency "libiconv"

# the url is the location of a redirect from sourceforge
source url: "http://downloads.sourceforge.net/project/nagiosplug/nagiosplug/1.4.15/nagios-plugins-#{version}.tar.gz",
       md5: "56abd6ade8aa860b38c4ca4a6ac5ab0d"

relative_path "nagios-plugins-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure" \
          " --prefix=#{install_dir}/embedded/nagios" \
          " --with-trusted-path=#{install_dir}/bin:#{install_dir}/embedded/bin:/bin:/sbin:/usr/bin:/usr/sbin" \
          " --with-openssl=#{install_dir}/embedded" \
          " --with-pgsql=#{install_dir}/embedded" \
          " --with-libiconv-prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "install", env: env

  # NOTE: cargo culted from commit 0e6eb2d4a7978c5683a3e15c956c0c2b78f3d904
  #
  # This is nasty but we don't use the check_ldap plugin and it has the
  # ugly habbit of linking against system `gnutls` instead of embedded
  # `openssl`. There is also no easy way to tell the configure task to
  # not build it!
  delete "#{install_dir}/embedded/nagios/libexec/check_ldap"
end
