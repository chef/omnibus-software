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

name "ffi-yajl"
default_version "master"
relative_path "ffi-yajl"

source git: "git://github.com/opscode/ffi-yajl"

if windows?
  dependency "ruby-windows"
  dependency "ruby-windows-devkit"
else
  dependency "libffi"
  dependency "ruby"
  dependency "rubygems"
end

dependency "libyajl2-gem"
dependency "bundler"

build do
  env = with_embedded_path()
  block do
    env['GEM_HOME'] = dest_dir + `#{dest_dir}/#{install_dir}/embedded/bin/ruby  -r rubygems -e 'p Gem.path.last' | tr -d '"' | tr -d '\n'`
    env['GEM_PATH'] = env['GEM_HOME']
    env['BUNDLE_PATH'] = env['GEM_HOME']

    bundle "config build.ffi-yajl --global --with-cflags='#{env['CFLAGS']}' --with-ldflags='#{env['LDFLAGS']}'", env: env
    bundle "install --without development_extras", env: env
    bundle "exec rake gem", env: env
  end

  delete "pkg/*java*"

  gem "install pkg/ffi-yajl-*.gem" \
      " --no-ri --no-rdoc", env: env
end
