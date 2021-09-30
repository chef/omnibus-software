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

name "ffi-yajl"
default_version "main"
relative_path "ffi-yajl"

source git: "https://github.com/chef/ffi-yajl.git"

license "MIT"
license_file "LICENSE"

dependency "ruby"

dependency "libyajl2-gem"

build do
  env = with_embedded_path

  # We should not be installing development dependencies either, but
  # this upstream bug causes issues between libyajl2-gem and ffi-yajl
  # (specifically, "corrupted Gemfile.lock" failures)
  # https://github.com/bundler/bundler/issues/4467
  bundle "config set --local without development_extras", env: env
  bundle "install", env: env
  bundle "exec rake gem", env: env

  delete "pkg/*java*"

  gem "install pkg/ffi-yajl-*.gem" \
      "  --no-document", env: env
end
