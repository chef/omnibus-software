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

source url: "https://opensearch.org/source.html"

# versions_list:https://opensearch.org/downloads.html
version "1.2.4" do
  source sha256: "cefeb8eb1a11cffbc78847e029588392b856915ccc521cbaea96544bff5e61a0"
end

target_path = "#{install_dir}/embedded/opensearch"

build do
  mkdir  "#{target_path}"
  sync   "#{project_dir}/", "#{target_path}"

  # Dropping a VERSION file here allows additional software definitions
  # to read it to determine ES plugin compatibility.
  command "echo #{version} > #{target_path}/VERSION"
end
