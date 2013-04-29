#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
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

name "libtool"
version "2.4"

source :url => "http://ftp.gnu.org/gnu/libtool/libtool-2.4.tar.gz",
       :md5 => "b32b04148ecdd7344abc6fe8bd1bb021"

relative_path "libtool-2.4"

build do
  command "./configure --prefix=#{install_dir}/embedded"
  command "make"
  command "make install"
end
