#
# Copyright:: Copyright (c) 2012-2019, Chef Software Inc.
# License:: Apache License, Version 2.0
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

# We use the version in util-linux, and only build the libuuid subdirectory
name "libsodium"
default_version "1.0.18"

license "ISC"
license_file "LICENSE"
skip_transitive_dependency_licensing true

# version_list: url=https://download.libsodium.org/libsodium/releases/ filter=*.tar.gz

version("1.0.17") { source sha256: "0cc3dae33e642cc187b5ceb467e0ad0e1b51dcba577de1190e9ffa17766ac2b1" }
version("1.0.18") { source sha256: "6f504490b342a4f8a4c4a02fc9b866cbef8622d5df4e5452b46be121e46636c1" }

source url: "https://download.libsodium.org/libsodium/releases/libsodium-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

relative_path "libsodium-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  configure "--disable-dependency-tracking", env: env
  make "-j #{workers}", env: env
  make "install", env: env
end
