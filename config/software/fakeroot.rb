#
# Copyright 2013-2014 Chef Software, Inc.
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

name "fakeroot"
default_version "1.20.2"

version "1.20.2" do
  source md5: "a4b4564a75024aa96c86e4d1017ac786"
end

source url: "http://http.debian.net/debian/pool/main/f/fakeroot/fakeroot_#{version}.orig.tar.bz2"

relative_path "fakeroot-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Patches for debain based platforms
  if ohai['platform_family'] == "debian"
    patch source: "eglibc-fts-without-LFS", plevel: 1
    patch source: "glibc-xattr-types", plevel: 1
  end

  command "./configure" \
          " --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
