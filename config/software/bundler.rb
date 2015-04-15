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
default_version "1.5.3"

if windows?
  dependency "ruby-windows"
else
  dependency "rubygems"
end

build do
  env = with_standard_compiler_flags(with_embedded_path)
  block do
    env['GEM_HOME'] = dest_dir + `#{dest_dir}/#{install_dir}/embedded/bin/ruby  -r rubygems -e 'p Gem.path.last' | tr -d '"' | tr -d '\n'`
    env['GEM_PATH'] = env['GEM_HOME']
  end

  gem "install bundler" \
      " --version '#{version}'" \
      " --no-ri --no-rdoc --bindir #{dest_dir}/#{install_dir}/embedded/bin", env: env
end
