#
# Copyright:: Copyright (c) Chef Software Inc.
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
# expeditor/ignore: no version pinning

name "inspec"
default_version "main"

license "Apache-2.0"
license_file "LICENSE"

source git: "https://github.com/chef/inspec.git"

dependency "ruby"
dependency "nokogiri"
# Dependency added to avoid this pry error:
# "Sorry, you can't use Pry without Readline or a compatible library."
dependency "rb-readline"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  bundle "config set --local without test integration tools maintenance", env: env
  bundle "install", env: env

  gem "build inspec.gemspec", env: env
  gem "install inspec-*.gem" \
      "  --no-document", env: env

  appbundle "inspec", env: env
end
