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

name "libunistring"
default_version "1.2"

license "MIT"
license_file "COPYING"
skip_transitive_dependency_licensing true

version("1.2") { source sha256: "632bd65ed74a881ca8a0309a1001c428bd1cbd5cd7ddbf8cedcd2e65f4dcdc44" }

source url: "https://ftp.gnu.org/gnu/libunistring/libunistring--#{version}.tar.xz"

internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

relative_path "libunistring-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  configure_options = [
    "--prefix=#{install_dir}/embedded",
  ]

  configure(*configure_options, env: env)

  make "-j #{workers}", env: env
  make "install", env: env
end
