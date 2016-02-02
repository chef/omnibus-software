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

name "mingw"
default_version "5.1.0-tdm64-1"

dependency "msys-base"
dependency "msys-coreutils-ext"
dependency "binutils"
dependency "mingw-runtime"

source url: "http://iweb.dl.sourceforge.net/project/tdm-gcc/TDM-GCC%205%20series/#{version}/gcc-#{version}-core.tar.lzma"

version("5.1.0-tdm64-1") { source sha256: "29393aac890847089ad1e93f81a28f6744b1609c00b25afca818f3903e42e4bd" }

build do
  copy "*", "#{install_dir}/embedded"
end
