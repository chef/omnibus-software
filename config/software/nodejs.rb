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
default_version "0.10.10"

dependency "python"

source url: "https://nodejs.org/dist/v#{version}/node-v#{version}.tar.gz"

# Warning: NodeJS 5.6.0 requires GCC >= 4.8
version("0.10.10") { source  md5: "a47a9141567dd591eec486db05b09e1c" }
version("0.10.26") { source  md5: "15e9018dadc63a2046f61eb13dfd7bd6" }
version("0.10.35") { source  md5: "2c00d8cf243753996eecdc4f6e2a2d11" }
version("4.1.2")   { source  md5: "31a3ee2f51bb2018501048f543ea31c7" }

relative_path "node-v#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "#{install_dir}/embedded/bin/python ./configure" \
          " --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
