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
## expeditor/ignore: deprecated 2022 03

name "nginx"
default_version "1.21.4"

dependency "pcre"
dependency "openssl"
dependency "zlib"

license "BSD-2-Clause"
license_file "LICENSE"

source url: "https://nginx.org/download/nginx-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

# versions_list: https://nginx.org/download/ filter=*.tar.gz
version("1.21.4") { source sha256: "d1f72f474e71bcaaf465dcc7e6f7b6a4705e4b1ed95c581af31df697551f3bfe" }
version("1.20.1") { source sha256: "e462e11533d5c30baa05df7652160ff5979591d291736cfa5edb9fd2edb48c49" }
version("1.19.9") { source sha256: "2e35dff06a9826e8aca940e9e8be46b7e4b12c19a48d55bfc2dc28fc9cc7d841" }
version("1.19.8") { source sha256: "308919b1a1359315a8066578472f998f14cb32af8de605a3743acca834348b05" }

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
