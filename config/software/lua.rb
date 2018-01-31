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
default_version "5.3.5"

version("5.1.5") do
  source md5: "2e115fe26e435e33b0d5c022e4490567"
  license_file "COPYRIGHT" # dropped in 5.2.x
end

version("5.2.4") { source sha256: "b9e2e4aad6789b3b63a056d442f7b39f0ecfca3ae0f1fc0ae4e9614401b69f4b" }

version("5.3.3") { source sha256: "5113c06884f7de453ce57702abaac1d618307f33f6789fa870e87a59d772aca2" }

version("5.3.4") { source sha256: "f681aa518233bc407e23acf0f5887c884f17436f000d453b2491a9f11a52400c" }

version("5.3.5") { source sha256: "0c2eed3f960446e1a3e4b9a1ca2f3ff893b6ce41942cf54d5dd59ab4b3b058ac" }

license "MIT"
license_file "https://www.lua.org/license.html"
skip_transitive_dependency_licensing true

source url: "https://www.lua.org/ftp/lua-#{version}.tar.gz"

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
