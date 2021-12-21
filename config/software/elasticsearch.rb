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
default_version "5.4.1"

dependency "server-open-jre"

license "Apache-2.0"
license_file "LICENSE.txt"
skip_transitive_dependency_licensing true

source url: "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-#{version}.tar.gz"
relative_path "elasticsearch-#{version}"

version "5.4.1" do
  source sha256: "09d6422bd33b82f065760cd49a31f2fec504f2a5255e497c81050fd3dceec485"
end

version "5.6.16" do
  source sha256: "6b035a59337d571ab70cea72cc55225c027ad142fbb07fd8984e54261657c77f"
end

version "6.8.1" do
  source sha512: "1d484287e9b67b16c28f1a4d2267e7ceb5a4438a18b26b3a46d4a176bb3f2f6fcadcbda617a7a91418293880d38c027266cb81a4e8893a28adee9fa693b2318b"
end

version "7.9.1" do
  source url: "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-#{version}-linux-x86_64.tar.gz",
         sha512: "e24aab0fbeb0b53cc386bb0ca1fc84c457851c5d80d147324bf97ff42f063332a93dec3c693550662393a72c7a0522a100181dd9a7d50b3e487a0f2a2a9bbcc0"
end

version "6.8.22" do
  source url: "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-#{version}.tar.gz",
         sha256: "836a50df324a98837dcadbc7d55782cc9525f15cc6a8aa0c657e199667ebb996"
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
