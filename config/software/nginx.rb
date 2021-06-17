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
default_version "1.20.1"

dependency "pcre"
dependency "openssl"
dependency "zlib"

license "BSD-2-Clause"
license_file "LICENSE"

source url: "https://nginx.org/download/nginx-#{version}.tar.gz"

# versions_list: https://nginx.org/download/ filter=*.tar.gz
version("1.20.1") { source sha256: "e462e11533d5c30baa05df7652160ff5979591d291736cfa5edb9fd2edb48c49" }
version("1.19.9") { source sha256: "2e35dff06a9826e8aca940e9e8be46b7e4b12c19a48d55bfc2dc28fc9cc7d841" }
version("1.19.8") { source sha256: "308919b1a1359315a8066578472f998f14cb32af8de605a3743acca834348b05" }
version("1.18.0") { source sha256: "4c373e7ab5bf91d34a4f11a0c9496561061ba5eee6020db272a17a7228d35f99" }
version("1.14.2") { source sha256: "002d9f6154e331886a2dd4e6065863c9c1cf8291ae97a1255308572c02be9797" }
version("1.14.0") { source sha256: "5d15becbf69aba1fe33f8d416d97edd95ea8919ea9ac519eff9bafebb6022cb5" }
version("1.12.2") { source sha256: "305f379da1d5fb5aefa79e45c829852ca6983c7cd2a79328f8e084a324cf0416" }
version("1.10.2") { source sha256: "1045ac4987a396e2fa5d0011daf8987b612dd2f05181b67507da68cbe7d765c2" }
version("1.9.1") { source sha256: "09f555fae694c0944f172b575ad239f56d40d14559d98e843de0a690f38c1dad" }
version("1.8.1") { source sha256: "8f4b3c630966c044ec72715754334d1fdf741caa1d5795fb4646c27d09f797b7" }
version("1.8.0") { source sha256: "23cca1239990c818d8f6da118320c4979aadf5386deda691b1b7c2c96b9df3d5" }
version("1.6.3") { source sha256: "0a98e95b366e4d6042f331e1fa4d70e18fd1e49d8993e589008e70e742b7e757" }
version("1.4.7") { source sha256: "23b8ff4a76817090678f91b0efbfcef59a93492f6612dc8370c44c1f1ce1b626" }
version("1.4.4") { source sha256: "7c989a58e5408c9593da0bebcd0e4ffc3d892d1316ba5042ddb0be5b0b4102b9" }

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
