#
# Copyright 2019 Chef Software, Inc.
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

name "go"
default_version "1.13.1"
license "BSD-3-Clause"
license_file "https://raw.githubusercontent.com/golang/go/master/LICENSE"

# Check golang releases at: https://golang.org/dl/
url_template = "https://dl.google.com/go/go#{version}.%{platform}-%{arch}.tar.gz"

# Default architecture
arch = "amd64"

if windows?
  platform = "windows"

  # On windows Go uses either '.zip' or '.msi'
  url_template = "https://dl.google.com/go/go#{version}.%{platform}-%{arch}.zip"

  version "1.13.1" do
    source sha256: "24cb08d369c1962cccacedc56fd79dc130f623b3b667a316554621ad6ac9b442",
           url: url_template % { platform: platform, arch: arch }
  end
elsif mac_os_x?
  platform = "darwin"

  version "1.13.1" do
    source sha256: "f3985fced3adecb62dd1e636cfa5eb9fea8f3e98101d9fcc4964d8f1ec255b7f",
           url: url_template % { platform: platform, arch: arch }
  end
else
  platform = "linux"

  version "1.13.1" do
    source sha256: "94f874037b82ea5353f4061e543681a0e79657f787437974214629af8407d124",
           url: url_template % { platform: platform, arch: arch }
  end
end

build do
  # We do not use 'sync' since we've found multiple errors with other software definitions
  copy "#{project_dir}/go", "#{install_dir}/embedded/go"
  %w{go gofmt}.each do |bin|
    link "#{install_dir}/embedded/go/bin/#{bin}", "#{install_dir}/embedded/bin/#{bin}"
  end
end
