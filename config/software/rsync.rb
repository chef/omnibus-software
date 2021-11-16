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

name "rsync"
default_version "3.2.2"

dependency "popt"

license_file "COPYING"
skip_transitive_dependency_licensing true

version "3.2.2" do
  source md5: "b82416e81dacc2065b0c7f48f73417dd"
  license "GPL-3.0"
  license_file "COPYING"
end

version "3.1.1" do
  source md5: "43bd6676f0b404326eee2d63be3cdcfe"
  license "GPL-3.0"
end

version "2.6.9" do
  source md5: "996d8d8831dbca17910094e56dcb5942"
  license "GPL-2.0"
end

source url: "https://rsync.samba.org/ftp/rsync/src/rsync-#{version}.tar.gz"

relative_path "rsync-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --disable-iconv", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
