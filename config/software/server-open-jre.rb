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
default_version "17.0.9+9"

unless _64_bit?
  raise "Server-open-jre can only be installed on x86_64 systems."
end

license "GPL-2.0 (with the Classpath Exception)"

# since the license url is getting timeouts and not reachable from some build nodes.
# we are using a local copy of the license file to avoid external network download issues. see below error
#  [Licensing] I | 2025-10-06T14:48:00+00:00 | Retrying failed download due to Net::ReadTimeout (1 retries left)...
#               [Licensing] E | 2025-10-06T14:50:05+00:00 | Download failed - Net::ReadTimeout!
#               [Licensing] W | 2025-10-06T14:50:05+00:00 | Can not download license file 'https://openjdk.org/legal/gplv2+ce.html' for software 'server-open-jre'.
license_file "licenses/gplv2+ce.html"
skip_transitive_dependency_licensing true

whitelist_file "jre/bin/javaws"
whitelist_file "jre/bin/policytool"
whitelist_file "jre/lib"
whitelist_file "jre/plugin"
whitelist_file "jre/bin/appletviewer"

license_warning = "By including the JRE, you accept the terms of AdoptOpenJRE."

# version_list: url=https://github.com/adoptium/temurin11-binaries/releases filter=*.tar.gz
name_folder = "server-open-jre"

version "17.0.9+9" do
  source url: "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.9%2B9/OpenJDK17U-jre_x64_linux_hotspot_17.0.9_9.tar.gz",
         sha256: "c37f729200b572884b8f8e157852c739be728d61d9a1da0f920104876d324733",
         warning: license_warning,
         unsafe: true
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name_folder}/OpenJDK17U-jre_x64_linux_hotspot_17.0.9_9.tar.gz",
                  authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end

version "11.0.28+6" do
  source url: "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.28%2B6/OpenJDK11U-jre_x64_linux_hotspot_11.0.28_6.tar.gz",
  sha256: "ddbd5d7ef14aa06784fb94d1e0e7177868dfdd0aa216a8a2e654869968ef7392",
  warning: license_warning,
  unsafe: true
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name_folder}/OpenJDK11U-jre_x64_linux_hotspot_11.0.28_6.tar.gz",
          authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end

version "11.0.22+7" do
  source url: "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.22%2B7/OpenJDK11U-jre_x64_linux_hotspot_11.0.22_7.tar.gz",
  sha256: "3a0fec1b9ef38d6abd86cf11f6001772b086096b6ec2588d2a02f1fa86b2b1de",
  warning: license_warning,
  unsafe: true
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name_folder}/OpenJDK11U-jre_x64_linux_hotspot_11.0.22_7.tar.gz",
           authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end

version "11.0.21+9" do
  source url: "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.21%2B9/OpenJDK11U-jre_x64_linux_hotspot_11.0.21_9.tar.gz",
  sha256: "156861bb901ef18759e05f6f008595220c7d1318a46758531b957b0c950ef2c3",
  warning: license_warning,
  unsafe: true
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name_folder}/OpenJDK11U-jre_x64_linux_hotspot_11.0.21_9.tar.gz",
           authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end

relative_path "jdk-#{version}-jre"

build do
  mkdir "#{install_dir}/embedded/open-jre"
  sync  "#{project_dir}/", "#{install_dir}/embedded/open-jre"

  # Patch RPATH so Java binaries can locate required shared libraries (e.g., libjli.so, libz.so)
  # in both the embedded OpenJRE and Omnibus environment.
  new_rpath = "#{install_dir}/embedded/open-jre/lib/jli:#{install_dir}/embedded/lib:$ORIGIN/../lib"

  Dir.glob("#{install_dir}/embedded/open-jre/bin/**/*").each do |bin|
    next unless File.file?(bin) && File.executable?(bin) && !File.symlink?(bin)

    file_output = shellout!("file -b #{bin}").stdout
    next unless file_output.include?("ELF")

    shellout!("#{install_dir}/embedded/bin/patchelf --set-rpath #{new_rpath} #{bin}")
  end
end