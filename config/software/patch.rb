#
# Copyright 2015 Chef Software, Inc.
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

name "patch"

dependency "config_guess"

if windows?
  # TODO more recent version now?
  default_version "2.6.1"
  dependency "mingw-get"
else
  default_version "2.7"

  version("2.7.5") { source md5: "ed4d5674ef4543b4eb463db168886dc7" }
  version("2.7") { source md5: "1cbaa223ff4991be9fae8ec1d11fb5ab" }
  source url: "https://ftp.gnu.org/gnu/patch/patch-#{version}.tar.gz"
  relative_path "patch-#{version}"
end

env = with_standard_compiler_flags(with_embedded_path)

build do

  update_config_guess(target: "build-aux")

  if windows?
    command "mingw-get.exe -v install msys-patch-bin=#{version}-*",
            env: env, cwd: "#{install_dir}/embedded"
  else
    configure "--disable-xattr", env: env
    make "-j #{workers}", env: env
    make "-j #{workers} install", env: env
  end
end
