#
# Copyright 2015-2018 Chef Software, Inc.
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

name "patch"

dependency "config_guess"

license "GPL-3.0"
license_file "COPYING"
skip_transitive_dependency_licensing true

default_version "2.7.6"

# version_list: url=https://ftp.gnu.org/gnu/patch/ filter=*.tar.gz

version("2.7.6") { source sha256: "8cf86e00ad3aaa6d26aca30640e86b0e3e1f395ed99f189b06d4c9f74bc58a4e" }
version("2.7.5") { source sha256: "7436f5a19f93c3ca83153ce9c5cbe4847e97c5d956e57a220121e741f6e7968f" }
version("2.7") { source sha256: "59c29f56faa0a924827e6a60c6accd6e2900eae5c6aaa922268c717f06a62048" }

source url: "https://ftp.gnu.org/gnu/patch/patch-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

relative_path "patch-#{version}"

env = with_standard_compiler_flags(with_embedded_path)

build do

  update_config_guess(target: "build-aux")

  configure "--disable-xattr", env: env
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
