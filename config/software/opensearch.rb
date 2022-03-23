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
default_version "1.2.4"

dependency "server-open-jre"
license "Apache-2.0"
license_file "LICENSE.txt"
skip_transitive_dependency_licensing true

source url: "https://artifacts.opensearch.org/releases/bundle/opensearch/#{version}/opensearch-#{version}-linux-x64.tar.gz"
relative_path "opensearch-#{version}"

# versions_list:https://opensearch.org/docs/latest/version-history/
version "1.2.4" do
  source sha256: "d40f2696623b6766aa235997e2847a6c661a226815d4ba173292a219754bd8a8"
end

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
