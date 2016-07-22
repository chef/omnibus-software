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

name "libyaml"
default_version "8a2d1e93b2a2"

source :url => "https://bitbucket.org/xi/libyaml/get/#{version}.tar.gz",
       :md5 => "601fbd125721460eee302d7d8b058434",
       :extract => :seven_zip

relative_path "xi-libyaml-#{version}"

env = with_embedded_path()
env = with_standard_compiler_flags(env)

build do
  ship_license "https://raw.githubusercontent.com/yaml/libyaml/master/LICENSE"
  command "./bootstrap"
  command "./configure --prefix=#{install_dir}/embedded", :env => env
  command "make -j #{workers}", :env => env
  command "make -j #{workers} install", :env => env
end
