#
# Copyright 2013-2014 Chef Software, Inc.
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

if ppc64? || ppc64le?
  default_version "0.10.38-release-ppc"
else
  default_version "0.10.10"
end

dependency "python"

default_src_url = "https://nodejs.org/dist/v#{version}/node-v#{version}.tar.gz"

version "0.10.10" do
  source url: default_src_url, md5: "a47a9141567dd591eec486db05b09e1c"
end

version "0.10.26" do
  source url: default_src_url, md5: "15e9018dadc63a2046f61eb13dfd7bd6"
end

version "0.10.35" do
  source url: default_src_url, md5: "2c00d8cf243753996eecdc4f6e2a2d11"
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


relative_path "node-v#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "#{install_dir}/embedded/bin/python ./configure" \
          " --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
