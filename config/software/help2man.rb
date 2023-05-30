#
# Copyright:: Copyright (c) 2012-2014 Chef Software, Inc.
# License:: Apache License, Version 2.0
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

name "help2man"
default_version "1.40.5"

source url: "https://ftp.gnu.org/gnu/help2man/help2man-1.40.5.tar.gz",
       sha256: "13599a89080628617f31ca1e7eee38d0b11b2c088708c14eba35b99d67b23cb4"

relative_path "help2man-1.40.5"

build do
  command "./configure --prefix=#{install_dir}/embedded"
  command "make -j #{workers}"
  command "make install"
end
