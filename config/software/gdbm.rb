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
# expeditor/ignore: deprecated 2021-11
#

name "gdbm"
default_version "1.8.3"

dependency "config_guess"

# Version 1.9 and above are GPLv3, do NOT add later versions in
version("1.8.3") { source md5: "1d1b1d5c0245b1c00aff92da751e9aa1" }

source url: "https://ftp.gnu.org/gnu/gdbm/gdbm-#{version}.tar.gz"

relative_path "gdbm-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  if version == "1.8.3"
    patch source: "v1.8.3-Makefile.in.patch", plevel: 0, env: env
  end

  update_config_guess

  if freebsd?
    command "./configure" \
            " --enable-libgdbm-compat" \
            " --with-pic" \
            " --prefix=#{install_dir}/embedded", env: env
  else
    command "./configure" \
            " --enable-libgdbm-compat" \
            " --prefix=#{install_dir}/embedded", env: env
  end

  make "-j #{workers}", env: env
  make "install", env: env
  make "install-compat", env: env
end
