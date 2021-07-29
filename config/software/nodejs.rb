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

name "nodejs"

license "MIT"
license_file "LICENSE"
skip_transitive_dependency_licensing true

if ppc64? || ppc64le? || s390x?
  default_version "0.10.38-release-ppc"
else
  default_version "0.10.48"
end

dependency "python"

default_src_url = "https://nodejs.org/dist/v#{version}/node-v#{version}.tar.gz"

version "12.22.3" do
  source url: default_src_url, sha256: "30acec454f26a168afe6d1c55307c5186ef23dba66527cc34e4497d01f91bda4"
end

version "0.10.48" do
  source url: default_src_url, sha256: "27a1765b86bf4ec9833e2f89e8421ba4bc01a326b883f125de2f0b3494bd5549"
end

version "0.10.35" do
  source url: default_src_url, sha256: "0043656bb1724cb09dbdc960a2fd6ee37d3badb2f9c75562b2d11235daa40a03"
end

version "0.10.38-release-ppc" do
  # This release is sourced from https://github.com/andrewlow/node but is packaged as
  #  a tarball here for consistency between builds and to enable omnibus caching.
  source url: "https://s3.amazonaws.com/chef-releng/node-v0.10.38-release-ppc.tar.gz",
         md5: "1ca1a2179b4b255e8fac839a92985cf5"
end

version "4.1.2" do
  source url: default_src_url, md5: "31a3ee2f51bb2018501048f543ea31c7"
end

# Warning: NodeJS 5.6.0 requires GCC >= 4.8
version "5.6.0" do
  source url: default_src_url, md5: "6f7c2cec289a20bcd970240dd63c1395"
end

relative_path "node-v#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "#{install_dir}/embedded/bin/python ./configure" \
          " --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
