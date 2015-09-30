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

name "bundler"
default_version "1.10.6"

dependency "rubygems"

version "1.10.7.depsolverfix.0" do
  source git: "https://github.com/chef/bundler.git"
end

build do
  env = with_standard_compiler_flags(with_embedded_path)

  if version == "1.10.7.depsolverfix.0"
    gem "build bundler.gemspec"
    gem "install bundler-#{version}.gem --no-ri --no-rdoc", env: env
  else
    gem "install bundler --version '#{version}' --no-ri --no-rdoc", env: env
  end
end
