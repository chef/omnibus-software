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

name "libyajl2-gem"
default_version "main"
relative_path "libyajl2-gem"

source git: "https://github.com/chef/libyajl2-gem.git"

license "Apache-2.0"
license_file "LICENSE"

dependency "ruby"

build do
  env = with_embedded_path

  command "git submodule init", env: env
  command "git submodule update", env: env

  bundle "config set --local without development_extras", env: env
  bundle "install", env: env
  bundle "exec rake prep", env: env
  bundle "exec rake gem", env: env

  delete "pkg/*java*"

  gem "install pkg/libyajl2-*.gem" \
      "  --no-document", env: env
end
