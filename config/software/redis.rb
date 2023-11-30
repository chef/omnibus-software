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
default_version "7.0.8"

version("7.2.3") { source sha256: "3e2b196d6eb4ddb9e743088bfc2915ccbb42d40f5a8a3edd8cb69c716ec34be7" }
version("7.0.8") { source sha256: "06a339e491306783dcf55b97f15a5dbcbdc01ccbde6dc23027c475cab735e914" }
version("7.0.4") { source sha256: "f0e65fda74c44a3dd4fa9d512d4d4d833dd0939c934e946a5c622a630d057f2f" }
version("7.0.2") { source sha256: "5e57eafe7d4ac5ecb6a7d64d6b61db775616dbf903293b3fcc660716dbda5eeb" }
version("7.0.0") { source sha256: "284d8bd1fd85d6a55a05ee4e7c31c31977ad56cbf344ed83790beeb148baa720" }
version("6.2.7") { source sha256: "b7a79cc3b46d3c6eb52fa37dde34a4a60824079ebdfb3abfbbfa035947c55319" }
version("6.2.6") { source sha256: "5b2b8b7a50111ef395bf1c1d5be11e6e167ac018125055daa8b5c2317ae131ab" }
version("6.2.5") { source sha256: "4b9a75709a1b74b3785e20a6c158cab94cf52298aa381eea947a678a60d551ae" }
version("5.0.14") { source sha256: "3ea5024766d983249e80d4aa9457c897a9f079957d0fb1f35682df233f997f32" }

source url: "https://download.redis.io/releases/redis-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

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
