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

name "cacerts"

license "MPL-2.0"
license_file "https://www.mozilla.org/media/MPL/2.0/index.815ca599c9df.txt"
skip_transitive_dependency_licensing true

default_version "2020-07-22"

source url: "https://curl.haxx.se/ca/cacert-#{version}.pem"

version("2020-07-22") { source sha256: "2782f0f8e89c786f40240fc1916677be660fb8d8e25dede50c9f6f7b0c2c2178" }
version("2020-06-24") { source sha256: "726889705b00f736200ed7999f7a50021b8735d53228d679c4e6665aa3b44987" }
version("2019-10-16") { source sha256: "5cd8052fcf548ba7e08899d8458a32942bf70450c9af67a0850b4c711804a2e4" }

relative_path "cacerts-#{version}"

build do
  mkdir "#{install_dir}/embedded/ssl/certs"

  copy "#{project_dir}/cacert*.pem", "#{install_dir}/embedded/ssl/certs/cacert.pem"
  copy "#{project_dir}/cacert*.pem", "#{install_dir}/embedded/ssl/cert.pem" if windows?

  # Windows does not support symlinks
  unless windows?
    link "certs/cacert.pem", "#{install_dir}/embedded/ssl/cert.pem", unchecked: true

    block { File.chmod(0644, "#{install_dir}/embedded/ssl/certs/cacert.pem") }
  end
end
