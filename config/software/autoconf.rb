#
# Copyright 2012-2014 Chef Software, Inc.
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

name "autoconf"
default_version "2.69"

license "GPL-3.0"
license_file "COPYING"
license_file "COPYING.EXCEPTION"
skip_transitive_dependency_licensing true

dependency "m4"

version "2.69" do
  source sha256: "954bd69b391edc12d6a4a51a2dd1476543da5c6bbf05a95b59dc0dd6fd4c2969"
end
version "2.68" do
  source sha256: "eff70a2916f2e2b3ed7fe8a2d7e63d72cf3a23684b56456b319c3ebce0705d99"
end

source url: "https://ftp.gnu.org/gnu/autoconf/autoconf-#{version}.tar.gz"

relative_path "autoconf-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  if solaris2?
    env["M4"] = "#{install_dir}/embedded/bin/m4"
  end

  command "./configure" \
          " --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
