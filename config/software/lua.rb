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
default_version "5.1.5"

version("5.1.5") { source md5: "2e115fe26e435e33b0d5c022e4490567" }

license "MIT"
license_file "COPYRIGHT"

source url: "https://www.lua.org/ftp/lua-#{version}.tar.gz"

relative_path "lua-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # lua compiles in a slightly interesting way, it has minimal configuration options
  # and only provides a makefile. We can't use use `-DLUA_USE_LINUX` or the `make linux`
  # methods because they make the assumption that the readline package has been installed.
  make "-j #{workers} posix", env: env, cwd: "#{project_dir}/src"
  make "-j #{workers} install INSTALL_TOP=#{install_dir}/embedded", env: env
end
