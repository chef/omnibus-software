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
default_version "3.1.1"

dependency "popt"

version "3.1.2" do
  source md5: "1be3ec9421f23e8eb7a06957992f6604"
end

version "3.1.1" do
  source md5: "43bd6676f0b404326eee2d63be3cdcfe"
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
