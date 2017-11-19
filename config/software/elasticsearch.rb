#
# Copyright 2016 Chef Software, Inc.
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
default_version "5.4.1"

dependency "server-jre"

license "Apache-2.0"
license_file "LICENSE.txt"
skip_transitive_dependency_licensing true

source url: "https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/#{version}/elasticsearch-#{version}.tar.gz"
relative_path "elasticsearch-#{version}"

version "2.3.1" do
  source sha256: "f0092e73038e0472fcdd923e5f2792e13692ea0f09ca034a54dd49b217110ebb"
end

version "2.4.1" do
  source sha256: "23a369ef42955c19aaaf9e34891eea3a055ed217d7fbe76da0998a7a54bbe167"
end

version "5.4.1" do
  # Newer versions appear to live in an alternative location that does
  # not also contain the older versions. We can make this default when we drop 2.x.
  source url: "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-#{version}.tar.gz",
         sha256: "09d6422bd33b82f065760cd49a31f2fec504f2a5255e497c81050fd3dceec485"
end

target_path = "#{install_dir}/embedded/elasticsearch"

build do
  mkdir  "#{target_path}"
  delete "#{project_dir}/lib/sigar/*solaris*"
  delete "#{project_dir}/lib/sigar/*sparc*"
  delete "#{project_dir}/lib/sigar/*freebsd*"
  delete "#{project_dir}/config"
  mkdir  "#{project_dir}/plugins"
  sync   "#{project_dir}/", "#{target_path}"

  # Dropping a VERSION file here allows additional software definitions
  # to read it to determine ES plugin compatibility.
  command "echo #{version} > #{target_path}/VERSION"
end
