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

name "redis"

license "BSD-3-Clause"
license_file "COPYING"
skip_transitive_dependency_licensing true

dependency "config_guess"
default_version "6.2.6"

version "6.2.6" do
  source sha256: "5b2b8b7a50111ef395bf1c1d5be11e6e167ac018125055daa8b5c2317ae131ab"
end

version "6.2.5" do
  source sha256: "4b9a75709a1b74b3785e20a6c158cab94cf52298aa381eea947a678a60d551ae"
end

version "5.0.14" do
  source sha256: "3ea5024766d983249e80d4aa9457c897a9f079957d0fb1f35682df233f997f32"
end

version "5.0.7" do
  source sha256: "61db74eabf6801f057fd24b590232f2f337d422280fd19486eca03be87d3a82b"
end

source url: "http://download.redis.io/releases/redis-#{version}.tar.gz"

relative_path "redis-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path).merge(
    "PREFIX" => "#{install_dir}/embedded"
  )

  update_config_guess

  if version.satisfies?("< 6.0")
    patch source: "password-from-environment.patch", plevel: 1, env: env
  end

  make "-j #{workers}", env: env
  make "install", env: env
end
