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
dependency "zlib"
dependency "patchelf"

name "server-open-jre"
default_version "11.0.28+6"

unless _64_bit?
  raise "Server-open-jre can only be installed on x86_64 systems."
end

license "GPL-2.0 (with the Classpath Exception)"

license_file "http://openjdk.java.net/legal/gplv2+ce.html"
skip_transitive_dependency_licensing true

whitelist_file "jre/bin/javaws"
whitelist_file "jre/bin/policytool"
whitelist_file "jre/lib"
whitelist_file "jre/plugin"
whitelist_file "jre/bin/appletviewer"

license_warning = "By including the JRE, you accept the terms of AdoptOpenJRE."

# version_list: url=https://github.com/adoptium/temurin11-binaries/releases filter=*.tar.gz
name-folder = "server-open-jre"

version "11.0.28+6" do
  source url: "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.28%2B6/OpenJDK11U-jre_x64_linux_hotspot_11.0.28_6.tar.gz",
  sha256: "ddbd5d7ef14aa06784fb94d1e0e7177868dfdd0aa216a8a2e654869968ef7392",
  warning: license_warning,
  unsafe: true
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name-folder}/OpenJDK11U-jre_x64_linux_hotspot_11.0.28_6.tar.gz",
          authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end

version "11.0.22+7" do
  source url: "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.22%2B7/OpenJDK11U-jre_x64_linux_hotspot_11.0.22_7.tar.gz",
  sha256: "3a0fec1b9ef38d6abd86cf11f6001772b086096b6ec2588d2a02f1fa86b2b1de",
  warning: license_warning,
  unsafe: true
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name-folder}/OpenJDK11U-jre_x64_linux_hotspot_11.0.22_7.tar.gz",
           authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end

version "11.0.21+9" do
  source url: "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.21%2B9/OpenJDK11U-jre_x64_linux_hotspot_11.0.21_9.tar.gz",
  sha256: "156861bb901ef18759e05f6f008595220c7d1318a46758531b957b0c950ef2c3",
  warning: license_warning,
  unsafe: true
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name-folder}/OpenJDK11U-jre_x64_linux_hotspot_11.0.21_9.tar.gz",
           authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end

version "11.0.20+8" do
  source url: "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.20%2B8/OpenJDK11U-jre_x64_linux_hotspot_11.0.20_8.tar.gz",
  sha256: "ffb070c26ea22771f78769c569c9db3412e6486434dc6df1fd3c3438285766e7",
  warning: license_warning,
  unsafe: true
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name-folder}/OpenJDK11U-jre_x64_linux_hotspot_11.0.20_8.tar.gz",
           authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end


version "11.0.15+10" do
  source url: "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.15%2B10/OpenJDK11U-jre_x64_linux_hotspot_11.0.15_10.tar.gz",
  sha256: "22831fd097dfb39e844cb34f42064ff26a0ada9cd13621d7b8bca8e9b9d3a5ee",
  warning: license_warning,
  unsafe: true
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name-folder}/OpenJDK11U-jre_x64_linux_hotspot_11.0.15_10.tar.gz",
           authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end

version "11.0.14.1+1" do
  source url: "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.14.1%2B1/OpenJDK11U-jre_x64_linux_hotspot_11.0.14.1_1.tar.gz",
  sha256: "b5a6960bc6bb0b1a967e307f908ea9b06ad7adbbd9df0b8954ab51374faa8a98",
  warning: license_warning,
  unsafe: true
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name-folder}/OpenJDK11U-jre_x64_linux_hotspot_11.0.14.1_1.tar.gz",
           authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end

relative_path "jdk-#{version}-jre"

build do
  mkdir "#{install_dir}/embedded/open-jre"
  sync  "#{project_dir}/", "#{install_dir}/embedded/open-jre"

  # Since we are using a precompiled-jre, it will look for zlib in the following path:
  # vagrant@default-ubuntu-1604:~$ chrpath jdk-11.0.4+11-jre/bin/java
  # jdk-11.0.4+11-jre/bin/java: RPATH=$ORIGIN/../lib/jli:$ORIGIN/../lib
  # This errors since it cannot find the libz.so.1 file that is installed
  # as a part of the omnibus environment.
  # We need to change the RPATH of the binary to be able to find omnibus installed zlib.

  new_rpath = "#{install_dir}/embedded/open-jre/lib/jli:#{install_dir}/embedded/lib:$ORIGIN/../lib"
  command "#{install_dir}/embedded/bin/patchelf --set-rpath #{new_rpath} #{install_dir}/embedded/open-jre/bin/*"
end
