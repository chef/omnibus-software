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

name "ohai"
default_version "v14.8.12"

license "Apache-2.0"
license_file "LICENSE"

source git: "https://github.com/chef/ohai.git"

relative_path "ohai"

dependency "ruby"
dependency "rubygems"
dependency "bundler"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  bundle "install --without development docs ci", env: env

  gem "build ohai.gemspec", env: env
  gem "install ohai*.gem" \
      "  --no-document", env: env
end
