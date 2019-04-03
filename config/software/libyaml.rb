#
# Copyright 2012-2019 Chef Software, Inc.
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
default_version "0.1.7"

license "MIT"
license_file "LICENSE"
skip_transitive_dependency_licensing true

dependency "config_guess"

version("0.2.2") { source sha256: "46bca77dc8be954686cff21888d6ce10ca4016b360ae1f56962e6882a17aa1fe" }
version("0.1.7") { source sha256: "e1884d0fa1eec8cf869ac6bebbf25391e81956aa2970267f974a9fa5e0b968e2" }
version("0.1.6") { source sha256: "a0ad4b8cfa4b26c669c178af08147449ea7e6d50374cc26503edc56f3be894cf" }

source url: "https://github.com/yaml/libyaml/archive/#{version}.tar.gz"

relative_path "yaml-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  update_config_guess(target: "config")

  configure "--enable-shared", env: env

  # Windows had worse automake/libtool version issues.
  # Just patch the output instead.
  if version >= "0.1.6" && windows?
    patch source: "v0.1.6.windows-configure.patch", plevel: 1, env: env
  end

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
