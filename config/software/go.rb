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
  version("1.21.4")  { source sha256: "6c62e89113750cc77c498194d13a03fadfda22bd2c7d44e8a826fd354db60252" }
  version("1.21.3")  { source sha256: "a1ddcaaf0821a12a800884c14cb4268ce1c1f5a0301e9060646f1e15e611c6c7" }
  version("1.19.5")  { source sha256: "ec14f04bdaf4a62bdcf8b55b9b6434cc27c2df7d214d0bb7076a7597283b026a" }
  version("1.19.1")  { source sha256: "efe93f5671621ee84ce5e262e1e21acbc72acefbaba360f21778abd083d4ad16" }
  version("1.19")    { source sha256: "25197c7d70c6bf2b34d7d7c29a2ff92ba1c393f0fb395218f1147aac2948fb93" }
  version("1.18.5")  { source sha256: "d5ac34ac5f060a5274319aa04b7b11e41b123bd7887d64efb5f44ead236957af" }
  version("1.18.3")  { source sha256: "b8f0b5db24114388d5dcba7ca0698510ea05228b0402fcbeb0881f74ae9cb83b" }
  version("1.18.2")  { source sha256: "570dc8df875b274981eaeabe228d0774985de42e533ffc8c7ff0c9a55174f697" }
  version("1.17.7")  { source sha256: "874774f078b182fa21ffcb3878467eb5cb7e78bbffa6343ea5f0fbe47983433b" }
  version("1.17.6")  { source sha256: "9ac723e6b41cb7c3651099a09332a8a778b69aa63a5e6baaa47caf0d818e2d6d" }
  version("1.17.5")  { source sha256: "aa1fb6c53b4fe72f159333362a10aca37ae938bde8adc9c6eaf2a8e87d1e47de" }
  version("1.17.2")  { source sha256: "04d16105008230a9763005be05606f7eb1c683a3dbf0fbfed4034b23889cb7f2" }
  version("1.17")    { source sha256: "ae89d33f4e4acc222bdb04331933d5ece4ae71039812f6ccd7493cb3e8ddfb4e" }
  version("1.16.3")  { source sha256: "0dae30385e3564a557dac7f12a63eedc73543e6da0f6017990e214ce8cc8797c" }

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
