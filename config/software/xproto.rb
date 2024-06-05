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

name "xproto"
default_version "7.0.31"

dependency "config_guess"

# version_list: url=https://www.x.org/releases/individual/proto/ filter=xproto-*.tar.gz

version("7.0.31") { source sha256: "6d755eaae27b45c5cc75529a12855fed5de5969b367ed05003944cf901ed43c7" }
version("7.0.28") { source sha256: "6cabc8ce3fa2b1a2427871167b62c24d5b08a58bd3e81ed7aaf08f2bf6dbcfed" }
version("7.0.25") { source sha256: "e3dc634103f923a2276289745eb7b702b18cfc885ea4b2382bd35a8cc3d935cb" }

source url: "https://www.x.org/releases/individual/proto/xproto-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
license "MIT"
license_file "COPYING"
skip_transitive_dependency_licensing true

relative_path "xproto-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  update_config_guess

  command "./configure" \
          " --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
