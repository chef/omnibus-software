#
# Copyright 2020 Chef Software, Inc.
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

name "opensearch"
default_version "2.4.1"

dependency "server-open-jre"
license "Apache-2.0"
license_file "LICENSE.txt"
skip_transitive_dependency_licensing true

source url: "https://artifacts.opensearch.org/releases/bundle/opensearch/#{version}/opensearch-#{version}-linux-x64.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
relative_path "opensearch-#{version}"

# versions_list:https://opensearch.org/docs/latest/version-history/
version("2.4.1") { source sha256: "f2b71818ad84cdab1b736211efbdd79d33835a92d46f66a237fa1182d012410d" }
version("2.4.0") { source sha256: "82bee5f68ea3d74a7d835d35f1479509b8497d01c1ae758a4737f5ea799e38e8" }
version("2.3.0") { source sha256: "696500b3126d2f2ad7216456cff1c58e8ea89402d76e0544a2e547549cf910ca" }
version("2.2.0") { source sha256: "4480c15682ddcd10cebb8a1103f4efafa789d7aee9d4c8c9201cd9864d5ed58c" }
version("2.1.0") { source sha256: "bccd737e0f4e4554d3918f011a1e379ebda9e53473c70b4264aa28ce719611e3" }
version("2.0.1") { source sha256: "8366dc71c839935330dbe841b415b37f28573de5ae7718e75f2e1c50756e0d99" }
version("2.0.0") { source sha256: "bec706d221052cb962ed0e6973d28e1058f21ef3dfc054c97c991bb279b0564e" }
version("1.3.2") { source sha256: "14199251a8aae2068fd54aa39c778ff29dcc8be33d57f36a8cc2d19e07ff4149" }
version("1.2.4") { source sha256: "d40f2696623b6766aa235997e2847a6c661a226815d4ba173292a219754bd8a8" }

target_path = "#{install_dir}/embedded/opensearch"

build do
  mkdir "#{target_path}"

  delete "#{project_dir}/config"

  # OpenSearch includes a compatible jdk but its files fail the omnibus health check.
  # It isn't needed since we use the omnibus built server-open-jre so it can be deleted.
  delete "#{project_dir}/jdk"

  # Delete the opensearch-knn plugin because it causes health check failures
  delete "#{project_dir}/plugins/opensearch-knn"

  sync "#{project_dir}/", "#{target_path}"
  # Dropping a VERSION file here allows additional software definitions
  # to read it to determine ES plugin compatibility.
  command "echo #{version} > #{target_path}/VERSION"
end
