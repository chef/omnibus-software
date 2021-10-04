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
default_version "1.17.1"
license "BSD-3-Clause"
license_file "https://raw.githubusercontent.com/golang/go/master/LICENSE"

# Defaults
platform = "linux"
arch = "amd64"
ext = "tar.gz"

if windows?
  platform = "windows"
  ext = "zip"

  # version_list: url=https://golang.org/dl/ filter=*.windows-amd64.zip
  version("1.17.1")  { source sha256: "2f2d0a5d7c59fb38fcacaf1e272cf701bb8c050300ba8b609fc30d2c5800f02e" }
  version("1.16.3")  { source sha256: "a4400345135b36cb7942e52bbaf978b66814738b855eeff8de879a09fd99de7f" }
  version("1.15.11") { source sha256: "56f63de17cd739287de6d9f3cfdad3b781ad3e4a18aae20ece994ee97c1819fd" }
  version("1.14.15") { source sha256: "189bc564d537d86f80c70757ee4c29fb1c2c6e8d05bb6de1242a03a96ac850cb" }
  version("1.13.15") { source sha256: "26c031d5dc2b39578943dbd34fe5c464ac4ed1c82f8de59f12999d3bf9f83ea1" }
  version("1.13.1")  { source sha256: "24cb08d369c1962cccacedc56fd79dc130f623b3b667a316554621ad6ac9b442" }
elsif mac_os_x?
  platform = "darwin"

  # version_list: url=https://golang.org/dl/ filter=*.darwin-amd64.tar.gz
  version("1.17.1")  { source sha256: "3c452046b1dfa27b70d3217c9fe6de266f9fd74d83aad81382fead70efcdffca" }
  version("1.16.3")  { source sha256: "6bb1cf421f8abc2a9a4e39140b7397cdae6aca3e8d36dcff39a1a77f4f1170ac" }
  version("1.15.11") { source sha256: "651c78408b2c047b7ccccb6b244c5de9eab927c87594ff6bd9540d43c9706671" }
  version("1.14.15") { source sha256: "cc116e7522d1d1bcb606ce413555c4f2d5c86c0c8d5e5074a0d57b303d8edb50" }
  version("1.13.15") { source sha256: "63180e32e9b7bfcd0c1c056e7c215299f662a1098a30316599c7b3e2e2fa28e7" }
  version("1.13.1")  { source sha256: "f3985fced3adecb62dd1e636cfa5eb9fea8f3e98101d9fcc4964d8f1ec255b7f" }
else
  # version_list: url=https://golang.org/dl/ filter=*.linux-amd64.tar.gz
  version("1.17.1")  { source sha256: "dab7d9c34361dc21ec237d584590d72500652e7c909bf082758fb63064fca0ef" }
  version("1.16.3")  { source sha256: "951a3c7c6ce4e56ad883f97d9db74d3d6d80d5fec77455c6ada6c1f7ac4776d2" }
  version("1.15.11") { source sha256: "8825b72d74b14e82b54ba3697813772eb94add3abf70f021b6bdebe193ed01ec" }
  version("1.14.15") { source sha256: "c64a57b374a81f7cf1408d2c410a28c6f142414f1ffa9d1062de1d653b0ae0d6" }
  version("1.13.15") { source sha256: "01cc3ddf6273900eba3e2bf311238828b7168b822bb57a9ccab4d7aa2acd6028" }
  version("1.13.1")  { source sha256: "94f874037b82ea5353f4061e543681a0e79657f787437974214629af8407d124" }
end

source url: "https://dl.google.com/go/go#{version}.%{platform}-%{arch}.%{ext}" % { platform: platform, arch: arch, ext: ext }

build do
  # We do not use 'sync' since we've found multiple errors with other software definitions
  copy "#{project_dir}/go", "#{install_dir}/embedded/go"
  %w{go gofmt}.each do |bin|
    link "#{install_dir}/embedded/go/bin/#{bin}", "#{install_dir}/embedded/bin/#{bin}"
  end
end
