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

# Defaults
platform = "linux"
arch = "amd64"
ext = "tar.gz"

if windows?
  platform = "windows"
  ext = "zip"

  # version_list: url=https://golang.org/dl/ filter=*.windows-amd64.zip
  version("1.23.12") { source sha256: "07c35866cdd864b81bb6f1cfbf25ac7f87ddc3a976ede1bf5112acbb12dfe6dc" }
  version("1.23.9")  { source sha256: "16409aa244b672de037389e9e39115cbf82633e5fa0d4db6ec1a9191ca00a1e1" }
  version("1.22.5")  { source sha256: "59968438b8d90f108fd240d4d2f95b037e59716995f7409e0a322dcb996e9f42" }
  version("1.21.5")  { source sha256: "bbe603cde7c9dee658f45164b4d06de1eff6e6e6b800100824e7c00d56a9a92f" }
  version("1.19.5")  { source sha256: "167db91a2e40aeb453d3e59d213ecab06f62e1c4a84d13a06ccda1d999961caa" }

  source url: "https://dl.google.com/go/go#{version}.%{platform}-%{arch}.%{ext}" % { platform: platform, arch: arch, ext: ext }
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.windows-amd64.zip",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

elsif mac_os_x?
  platform = "darwin"
  if intel?
    arch = "amd64"
    # version_list: url=https://golang.org/dl/ filter=*.darwin-amd64.tar.gz
    version("1.23.12") { source sha256: "0f6efdc3ffc6f03b230016acca0aef43c229de022d0ff401e7aa4ad4862eca8e" }
    version("1.23.9")  { source sha256: "50200cba5173100a6e880098cf3b2db4063394beaf7374e9766b6c19bb18012d" }
    version("1.22.5")  { source sha256: "95d9933cdcf45f211243c42c7705c37353cccd99f27eb4d8e2d1bf2f4165cb50" }
    version("1.21.5")  { source sha256: "a2e1d5743e896e5fe1e7d96479c0a769254aed18cf216cf8f4c3a2300a9b3923" }
    version("1.19.5")  { source sha256: "23d22bb6571bbd60197bee8aaa10e702f9802786c2e2ddce5c84527e86b66aa0" }
    source url: "https://dl.google.com/go/go#{version}.%{platform}-%{arch}.%{ext}" % { platform: platform, arch: arch, ext: ext }
    internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.darwin-amd64.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
  else
    arch = "arm64"
    # version_list: url=https://golang.org/dl/ filter=*.darwin-arm64.tar.gz
    version("1.23.12") { source sha256: "5bfa117e401ae64e7ffb960243c448b535fe007e682a13ff6c7371f4a6f0ccaa" }
    version("1.23.9")  { source sha256: "2bf624b6399e41248255858b2d61abae2703eecafad39808449951f3f1ab3766" }
    version("1.22.5")  { source sha256: "4cd1bcb05be03cecb77bccd765785d5ff69d79adf4dd49790471d00c06b41133" }
    version("1.21.5")  { source sha256: "d0f8ac0c4fb3efc223a833010901d02954e3923cfe2c9a2ff0e4254a777cc9cc" }

    source url: "https://dl.google.com/go/go#{version}.%{platform}-%{arch}.%{ext}" % { platform: platform, arch: arch, ext: ext }
    internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.darwin-arm64.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
  end
elsif armhf?
  arch = "armv6l"
  # version_list: url=https://golang.org/dl/ filter=*.linux-armv6l.tar.gz
  version("1.23.12") { source sha256: "9704eba01401a3793f54fac162164b9c5d8cc6f3cab5cee72684bb72294d9f41" }
  version("1.23.9")  { source sha256: "ade33880caacb8919b48767e0957e9880f2cdf634e137402a6f22552504136dd" }
  version("1.22.5")  { source sha256: "8c4587cf3e63c9aefbcafa92818c4d9d51683af93ea687bf6c7508d6fa36f85e" }
  version("1.21.5")  { source sha256: "837f4bf4e22fcdf920ffeaa4abf3d02d1314e03725431065f4d44c46a01b42fe" }
  version("1.19.5")  { source sha256: "ec14f04bdaf4a62bdcf8b55b9b6434cc27c2df7d214d0bb7076a7597283b026a" }

  source url: "https://dl.google.com/go/go#{version}.%{platform}-%{arch}.%{ext}" % { platform: platform, arch: arch, ext: ext }
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.linux-armv6l.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

elsif arm?
  arch = "arm64"
  # version_list: url=https://golang.org/dl/ filter=*.linux-arm64.tar.gz
  version("1.23.12") { source sha256: "52ce172f96e21da53b1ae9079808560d49b02ac86cecfa457217597f9bc28ab3" }
  version("1.23.9")  { source sha256: "3dc4dd64bdb0275e3ec65a55ecfc2597009c7c46a1b256eefab2f2172a53a602" }
  version("1.22.5")  { source sha256: "8d21325bfcf431be3660527c1a39d3d9ad71535fabdf5041c826e44e31642b5a" }
  version("1.21.5")  { source sha256: "841cced7ecda9b2014f139f5bab5ae31785f35399f236b8b3e75dff2a2978d96" }
  version("1.19.5")  { source sha256: "fc0aa29c933cec8d76f5435d859aaf42249aa08c74eb2d154689ae44c08d23b3" }

  source url: "https://dl.google.com/go/go#{version}.%{platform}-%{arch}.%{ext}" % { platform: platform, arch: arch, ext: ext }
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.linux-arm64.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

else
  # version_list: url=https://golang.org/dl/ filter=*.linux-amd64.tar.gz
  version("1.23.12") { source sha256: "d3847fef834e9db11bf64e3fb34db9c04db14e068eeb064f49af747010454f90" }
  version("1.23.9")  { source sha256: "de03e45d7a076c06baaa9618d42b3b6a0561125b87f6041c6397680a71e5bb26" }
  version("1.22.5")  { source sha256: "904b924d435eaea086515bc63235b192ea441bd8c9b198c507e85009e6e4c7f0" }
  version("1.21.5")  { source sha256: "e2bc0b3e4b64111ec117295c088bde5f00eeed1567999ff77bc859d7df70078e" }
  version("1.19.5")  { source sha256: "36519702ae2fd573c9869461990ae550c8c0d955cd28d2827a6b159fda81ff95" }

  source url: "https://dl.google.com/go/go#{version}.%{platform}-%{arch}.%{ext}" % { platform: platform, arch: arch, ext: ext }
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.linux-amd64.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end
build do
  # We do not use 'sync' since we've found multiple errors with other software definitions
  mkdir "#{install_dir}/embedded/go"
  copy "#{project_dir}/go/*", "#{install_dir}/embedded/go"

  mkdir "#{install_dir}/embedded/bin"
  %w{go gofmt}.each do |bin|
    link "#{install_dir}/embedded/go/bin/#{bin}", "#{install_dir}/embedded/bin/#{bin}"
  end
end