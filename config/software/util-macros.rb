#
# Copyright 2014 Chef Software, Inc.
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

name "util-macros"
default_version "1.19.3"

# version_list: url=https://www.x.org/releases/individual/util/ filter=util-macros-*.tar.gz

version("1.19.3") { source sha256: "624bb6c3a4613d18114a7e3849a3d70f2d7af9dc6eabeaba98060d87e3aef35b" }
version("1.19.0") { source sha256: "0d4df51b29023daf2f63aebf3ebc638ea88efedfd560ab5866741ab3f92acaa1" }
version("1.18.0") { source sha256: "cf4ab0e17bfee0f7689cdcff8c7d7f164c9a710f851f91c488f5cd81fac9c0aa" }

source url: "https://www.x.org/releases/individual/util/util-macros-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

license "MIT"
license_file "COPYING"
skip_transitive_dependency_licensing true

relative_path "util-macros-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure" \
          " --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
