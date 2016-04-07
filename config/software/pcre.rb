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

name "pcre"
default_version "8.38"

license "BSD-2-Clause"
license_file "LICENCE"

dependency "libedit"
dependency "ncurses"

version "8.38" do
  source md5: "8a353fe1450216b6655dfcf3561716d9"
end

version "8.31" do
  source md5: "fab1bb3b91a4c35398263a5c1e0858c1"
end

source url: "http://iweb.dl.sourceforge.net/project/pcre/pcre/#{version}/pcre-#{version}.tar.gz"

relative_path "pcre-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --enable-utf" \
          " --enable-unicode-properties" \
          " --enable-pcretest-libedit", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
