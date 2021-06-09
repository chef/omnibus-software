#
# Copyright 2012-2019 Chef Software, Inc.
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

name "make"
default_version "4.3"

license "GPL-3.0"
license_file "COPYING"

# version_list: url=https://ftp.gnu.org/gnu/make/ filter=*.tar.gz

version("4.3")   { source sha256: "e05fdde47c5f7ca45cb697e973894ff4f5d79e13b750ed57d7b66d8defc78e19" }
version("4.2.1") { source sha256: "e40b8f018c1da64edd1cc9a6fce5fa63b2e707e404e20cad91fbae337c98a5b7" }
version("4.1")   { source sha256: "9fc7a9783d3d2ea002aa1348f851875a2636116c433677453cc1d1acc3fc4d55" }

source url: "https://ftp.gnu.org/gnu/make/make-#{version}.tar.gz"

relative_path "make-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Work around an error caused by Glibc 2.27
  # Thanks to: http://www.linuxfromscratch.org/lfs/view/8.2/chapter05/make.html
  if (debian? &&  platform_version.satisfies?(">= 10")) || (ubuntu? && platform_version.satisfies?(">= 18.04")) || raspbian?
    patch -p1 source: "deb-make-glob.patch", plevel: 1, env: env
  end

  command "./configure" \
          " --disable-nls" \
          " --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "install", env: env

  # We are very prescriptive. We made make, we will make all the things use it!
  link "#{install_dir}/embedded/bin/make", "#{install_dir}/embedded/bin/gmake"
end
