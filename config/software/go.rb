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
default_version "1.17.7"
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
  version("1.17.7")  { source sha256:  "1b648165d62a2f5399f3c42c7e59de9f4aa457212c4ea763e1b650546fac72e2" }
  version("1.17.6")  { source sha256: "5bf8f87aec7edfc08e6bc845f1c30dba6de32b863f89ae46553ff4bbcc1d4954" }
  version("1.17.5")  { source sha256: "671faf99cd5d81cd7e40936c0a94363c64d654faa0148d2af4bbc262555620b9" }
  version("1.17.2")  { source sha256: "fa6da0b829a66f5fab7e4e312fd6aa1b2d8f045c7ecee83b3d00f6fe5306759a" }
  version("1.17")    { source sha256: "2a18bd65583e221be8b9b7c2fbe3696c40f6e27c2df689bbdcc939d49651d151" }
  version("1.16.3")  { source sha256: "a4400345135b36cb7942e52bbaf978b66814738b855eeff8de879a09fd99de7f" }
elsif mac_os_x?
  platform = "darwin"

  # version_list: url=https://golang.org/dl/ filter=*.darwin-amd64.tar.gz
  version("1.17.7")  { source sha256: "7c3d9cc70ee592515d92a44385c0cba5503fd0a9950f78d76a4587916c67a84d" }
  version("1.17.6")  { source sha256: "874bc6f95e07697380069a394a21e05576a18d60f4ba178646e1ebed8f8b1f89" }
  version("1.17.5")  { source sha256: "2db6a5d25815b56072465a2cacc8ed426c18f1d5fc26c1fc8c4f5a7188658264" }
  version("1.17.2")  { source sha256: "7914497a302a132a465d33f5ee044ce05568bacdb390ab805cb75a3435a23f94" }
  version("1.17")    { source sha256: "355bd544ce08d7d484d9d7de05a71b5c6f5bc10aa4b316688c2192aeb3dacfd1" }
  version("1.16.3")  { source sha256: "6bb1cf421f8abc2a9a4e39140b7397cdae6aca3e8d36dcff39a1a77f4f1170ac" }
else
  # version_list: url=https://golang.org/dl/ filter=*.linux-amd64.tar.gz
  version("1.17.7")  { source sha256: "02b111284bedbfa35a7e5b74a06082d18632eff824fd144312f6063943d49259" }
  version("1.17.6")  { source sha256: "231654bbf2dab3d86c1619ce799e77b03d96f9b50770297c8f4dff8836fc8ca2" }
  version("1.17.5")  { source sha256: "bd78114b0d441b029c8fe0341f4910370925a4d270a6a590668840675b0c653e" }
  version("1.17.2")  { source sha256: "f242a9db6a0ad1846de7b6d94d507915d14062660616a61ef7c808a76e4f1676" }
  version("1.17")    { source sha256: "6bf89fc4f5ad763871cf7eac80a2d594492de7a818303283f1366a7f6a30372d" }
  version("1.16.3")  { source sha256: "951a3c7c6ce4e56ad883f97d9db74d3d6d80d5fec77455c6ada6c1f7ac4776d2" }
end

source url: "https://dl.google.com/go/go#{version}.%{platform}-%{arch}.%{ext}" % { platform: platform, arch: arch, ext: ext }

build do
  # We do not use 'sync' since we've found multiple errors with other software definitions
  mkdir "#{install_dir}/embedded/go"
  copy "#{project_dir}/go/*", "#{install_dir}/embedded/go"

  mkdir "#{install_dir}/embedded/bin"
  %w{go gofmt}.each do |bin|
    link "#{install_dir}/embedded/go/bin/#{bin}", "#{install_dir}/embedded/bin/#{bin}"
  end
end
