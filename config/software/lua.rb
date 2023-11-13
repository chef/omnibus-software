#
# Copyright 2016 Chef Software, Inc.
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

name "lua"
default_version "5.4.6"

# versions_list: https://www.lua.org/ftp/ filter=*.tar.gz
version("5.4.6") { source sha256: "7d5ea1b9cb6aa0b59ca3dde1c6adcb57ef83a1ba8e5432c0ecd06bf439b3ad88" }
version("5.4.4") { source sha256: "164c7849653b80ae67bec4b7473b884bf5cc8d2dca05653475ec2ed27b9ebf61" }
version("5.4.3") { source sha256: "f8612276169e3bfcbcfb8f226195bfc6e466fe13042f1076cbde92b7ec96bbfb" }
version("5.4.2") { source sha256: "11570d97e9d7303c0a59567ed1ac7c648340cd0db10d5fd594c09223ef2f524f" }
version("5.3.3") { source sha256: "5113c06884f7de453ce57702abaac1d618307f33f6789fa870e87a59d772aca2" }
version("5.2.4") { source sha256: "b9e2e4aad6789b3b63a056d442f7b39f0ecfca3ae0f1fc0ae4e9614401b69f4b" }

license "MIT"
license_file "https://www.lua.org/license.html"
skip_transitive_dependency_licensing true

source url: "https://www.lua.org/ftp/lua-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

relative_path "lua-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # lua compiles in a slightly interesting way, it has minimal configuration options
  # and only provides a makefile. We can't use use `-DLUA_USE_LINUX` or the `make linux`
  # methods because they make the assumption that the readline package has been installed.
  mycflags = "-I#{install_dir}/embedded/include -O2 -DLUA_USE_POSIX -DLUA_USE_DLOPEN"
  myldflags = "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib"
  mylibs = "-ldl"
  make "all MYCFLAGS='#{mycflags}' MYLDFLAGS='#{myldflags}' MYLIBS='#{mylibs}'", env: env, cwd: "#{project_dir}/src"
  make "-j #{workers} install INSTALL_TOP=#{install_dir}/embedded", env: env
end
