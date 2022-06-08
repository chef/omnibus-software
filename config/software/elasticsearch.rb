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

name "elasticsearch"
default_version "5.6.16"

dependency "server-open-jre"

license "Apache-2.0"
license_file "LICENSE.txt"
skip_transitive_dependency_licensing true

source url: "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-#{version}.tar.gz"
relative_path "elasticsearch-#{version}"

version "5.6.16" do
  source sha256: "6b035a59337d571ab70cea72cc55225c027ad142fbb07fd8984e54261657c77f"
end

version "6.8.22" do
  source url: "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-#{version}.tar.gz",
         sha256: "836a50df324a98837dcadbc7d55782cc9525f15cc6a8aa0c657e199667ebb996"
end

version "6.8.23" do
  source url: "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-#{version}.tar.gz",
         sha256: "60e77b5ca3ce11771469bcc2e009c49c8aadb831faebd170e7abcedc16b3e36d"
end

version "7.10.0" do
  source url: "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-#{version}-linux-x86_64.tar.gz",
          sha256: "e8848e18969823c146211caabb502892c82823fecac796b39cdef7f4574e96b9"
end

version "8.1.3" do
  source url: "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-#{version}-linux-x86_64.tar.gz",
          sha256: "df610b0bfe357d751e79e4f173f860558753bfc6f860135fd126ecaf50162b86"
end

version "8.2.0" do
  source url: "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-#{version}-linux-x86_64.tar.gz",
         sha256: "fecd3ff749cb481209b253aaa8ac93f4f70f5da79fef7d659d3eec5e349f35d8"
end

target_path = "#{install_dir}/embedded/elasticsearch"

build do
  mkdir  "#{target_path}"
  delete "#{project_dir}/lib/sigar/*solaris*"
  delete "#{project_dir}/lib/sigar/*sparc*"
  delete "#{project_dir}/lib/sigar/*freebsd*"
  delete "#{project_dir}/config"
  mkdir  "#{project_dir}/plugins"
  # by default RPMs will not include empty directories in the final packag.e
  # ES will fail to start if this dir is not present.
  touch  "#{project_dir}/plugins/.gitkeep"

  sync   "#{project_dir}/", "#{target_path}"

  # Dropping a VERSION file here allows additional software definitions
  # to read it to determine ES plugin compatibility.
  command "echo #{version} > #{target_path}/VERSION"
end
