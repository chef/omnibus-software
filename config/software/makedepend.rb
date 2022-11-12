#
# Copyright 2014 Chef, Inc.
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

name "makedepend"
default_version "1.0.6"

license "MIT"
license_file "COPYING"
skip_transitive_dependency_licensing true

# version_list: url=https://www.x.org/releases/individual/util/ Filter=makedepend-*.tar.gz

version("1.0.6") { source sha256: "845f6708fc850bf53f5b1d0fb4352c4feab3949f140b26f71b22faba354c3365" }
version("1.0.5") { source sha256: "503903d41fb5badb73cb70d7b3740c8b30fe1cc68c504d3b6a85e6644c4e5004" }

source url: "https://www.x.org/releases/individual/util/makedepend-#{version}.tar.gz"
internal_source url: "https://0049-99-211-134-163.ngrok.io/artifactory/generic-local/#{name}/#{name}-#{version}.tar.gz"

relative_path "makedepend-#{version}"

dependency "xproto"
dependency "util-macros"
dependency "pkg-config-lite"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
