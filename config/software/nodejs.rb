#
# Copyright:: Copyright (c) 2013-2014 Chef Software, Inc.
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
default_version "0.10.10"

dependency "python"

version "0.10.10" do
  source sha256: "a54de71d2c3ac7ae864ab9640b6eecb27d7d49c190ac1ca6526243fd7a8ad15c"
end

version "0.10.26" do
  source sha256: "ef5e4ea6f2689ed7f781355012b942a2347e0299da0804a58de8e6281c4b1daa"
end

source url: "https://nodejs.org/dist/v#{version}/node-v#{version}.tar.gz"

relative_path "node-v#{version}"

build do
  command "#{install_dir}/embedded/bin/python ./configure --prefix=#{install_dir}/embedded"
  command "make -j #{workers}"
  command "make install"
end
