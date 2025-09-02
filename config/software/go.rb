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
default_version "1.19.5"
license "BSD-3-Clause"
license_file "https://raw.githubusercontent.com/golang/go/master/LICENSE"

# version_list: url=https://golang.org/dl/ filter=*.tar.gz
version("1.23.12") { source sha256: "9704eba01401a3793f54fac162164b9c5d8cc6f3cab5cee72684bb72294d9f41" }
version("1.23.9")  { source sha256: "ade33880caacb8919b48767e0957e9880f2cdf634e137402a6f22552504136dd" }
version("1.22.5")  { source sha256: "8c4587cf3e63c9aefbcafa92818c4d9d51683af93ea687bf6c7508d6fa36f85e" }
version("1.21.5")  { source sha256: "837f4bf4e22fcdf920ffeaa4abf3d02d1314e03725431065f4d44c46a01b42fe" }
  
source url: "https://dl.google.com/go/go#{version}.%{platform}-%{arch}.%{ext}" % { platform: platform, arch: arch, ext: ext }
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.%{platform}-%{arch}.%{ext}",
              authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

build do
  # We do not use 'sync' since we've found multiple errors with other software definitions
  mkdir "#{install_dir}/embedded/go"
  copy "#{project_dir}/go/*", "#{install_dir}/embedded/go"

  mkdir "#{install_dir}/embedded/bin"
  %w{go gofmt}.each do |bin|
    link "#{install_dir}/embedded/go/bin/#{bin}", "#{install_dir}/embedded/bin/#{bin}"
  end
end
