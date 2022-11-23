#
# Copyright:: Chef Software, Inc.
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

name "libyaml"
default_version "0.2.5"

license "MIT"
license_file "LICENSE"
skip_transitive_dependency_licensing true

dependency "config_guess"

# versions_list: https://pyyaml.org/download/libyaml/ filter=*.tar.gz
version("0.2.5") { source sha256: "c642ae9b75fee120b2d96c712538bd2cf283228d2337df2cf2988e3c02678ef4" }
version("0.2.4") { source sha256: "d80aeda8747b7c26fbbfd87ab687786e58394a8435ae3970e79cb97882e30557" }
version("0.1.7") { source sha256: "8088e457264a98ba451a90b8661fcb4f9d6f478f7265d48322a196cec2480729" }

source url: "https://pyyaml.org/download/libyaml/yaml-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/yaml-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

relative_path "yaml-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  update_config_guess(target: "config")

  configure "--enable-shared", env: env

  # Windows had worse automake/libtool version issues.
  # Just patch the output instead.
  if windows? && version.satisfies?("< 0.2.5")
    patch source: "windows-configure.patch", plevel: 1, env: env
  end

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
