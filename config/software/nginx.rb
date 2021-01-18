#
# Copyright 2012-2016 Chef Software, Inc.
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

name "nginx"
default_version "1.18.0"

dependency "pcre"
dependency "openssl"

license "BSD-2-Clause"
license_file "LICENSE"

source url: "https://nginx.org/download/nginx-#{version}.tar.gz"

version("1.18.0") { source sha256: "4c373e7ab5bf91d34a4f11a0c9496561061ba5eee6020db272a17a7228d35f99" }
version("1.14.2") { source sha256: "002d9f6154e331886a2dd4e6065863c9c1cf8291ae97a1255308572c02be9797" }
version("1.14.0") { source sha256: "5d15becbf69aba1fe33f8d416d97edd95ea8919ea9ac519eff9bafebb6022cb5" }
version("1.12.2") { source sha256: "305f379da1d5fb5aefa79e45c829852ca6983c7cd2a79328f8e084a324cf0416" }
version("1.10.2") { source md5: "e8f5f4beed041e63eb97f9f4f55f3085" }
version("1.9.1") { source md5: "fc054d51effa7c80a2e143bc4e2ae6a7" }
version("1.8.1") { source md5: "2e91695074dbdfbf1bcec0ada9fda462" }
version("1.8.0") { source md5: "3ca4a37931e9fa301964b8ce889da8cb" }
version("1.6.3") { source md5: "ea813aee2c344c2f5b66cdb24a472738" }
version("1.4.7") { source md5: "aee151d298dcbfeb88b3f7dd3e7a4d17" }
version("1.4.4") { source md5: "5dfaba1cbeae9087f3949860a02caa9f" }

relative_path "nginx-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --with-http_ssl_module" \
          " --with-http_stub_status_module" \
          " --with-ipv6" \
          " --with-debug" \
          " --with-cc-opt=\"-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include\"" \
          " --with-ld-opt=-L#{install_dir}/embedded/lib", env: env

  make "-j #{workers}", env: env
  make "install", env: env

  # Ensure the logs directory is available on rebuild from git cache
  touch "#{install_dir}/embedded/logs/.gitkeep"
end
