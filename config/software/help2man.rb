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
# expeditor/ignore: deprecated 2021-04

name "help2man"
default_version "1.40.5"

version "1.47.3" do
  source url: "https://ftp.gnu.org/gnu/help2man/help2man-1.47.3.tar.xz",
         md5: "d1d44a7a7b2bd61755a2045d96ecaea0"
end

version "1.40.5" do
  source url: "https://ftp.gnu.org/gnu/help2man/help2man-1.40.5.tar.gz",
         md5: "75a7d2f93765cd367aab98986a75f88c"
end

relative_path "help2man-1.40.5"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure --prefix=#{install_dir}/embedded", env: env

  make env: env
  make "install", env: env
end
