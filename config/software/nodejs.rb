#
# Copyright:: Copyright (c) 2013 Opscode, Inc.
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

name "nodejs"
version "0.10.7"

source :url => "http://nodejs.org/dist/v0.10.7/node-v0.10.7.tar.gz",
       :md5 => "f7cd44c8604755ceb8668598f4d9b931"

relative_path "node-v0.10.7"

build do
  command "./configure --prefix=#{install_dir}/embedded"
  command "make -j #{max_build_jobs}"
  command "make install"
end
