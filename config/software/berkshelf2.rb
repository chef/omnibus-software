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

Omnibus.logger.deprecated('berkshelf2') do
  'Please upgrade to Berkshelf 3. Continued use of Berkshelf 2 will not be supported in the future.'
end

name "berkshelf2"
default_version "2.0.18"

dependency "ruby"
dependency "rubygems"
dependency "nokogiri"
dependency "libffi"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  gem "install hashie" \
      " --version '~> 2.0.0'" \
      " --no-ri --no-rdoc", env: env

  gem "install varia_model" \
      " --version '0.3.2'" \
      " --no-ri --no-rdoc", env: env

  gem "install i18n" \
      " --version '0.6.11'" \
      " --no-ri --no-rdoc", env: env

  gem "install berkshelf" \
      " --version '#{version}'" \
      " --no-ri --no-rdoc", env: env
end
