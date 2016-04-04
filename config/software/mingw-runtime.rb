#
# Copyright 2012-2015 Chef Software, Inc.
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

name "mingw-runtime"
default_version "v4-git20150618-gcc5-tdm64-1"

dependency "msys-base"

source url: "http://iweb.dl.sourceforge.net/project/tdm-gcc/MinGW-w64%20runtime/GCC%205%20series/mingw64runtime-#{version}.tar.lzma"

version("v4-git20150618-gcc5-tdm64-1") { source sha256: "29186e0bb36824b10026d78bdcf238d631d8fc1d90718d2ebbd9ec239b6f94dd" }

build do
  copy "*", "#{install_dir}/embedded"
end
