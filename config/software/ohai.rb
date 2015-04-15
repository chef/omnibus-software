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

name "ohai"

if windows?
  dependency "ruby-windows"
  dependency "ruby-windows-devkit"
else
  dependency "ruby"
  dependency "libffi"
  dependency "rubygems"
end

dependency "bundler"

default_version "master"

source git: "git://github.com/opscode/ohai"

relative_path "ohai"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  block do
    env['GEM_HOME'] = dest_dir + `#{dest_dir}/#{install_dir}/embedded/bin/ruby  -r rubygems -e 'p Gem.path.last' | tr -d '"' | tr -d '\n'`
    env['GEM_PATH'] = env['GEM_HOME']
    env['BUNDLE_PATH'] = env['GEM_HOME']
  end

  block do
    bundle "config build.ffi '--with-cflags=\"#{env['CFLAGS']}\" --with-ldflags=\"#{env['LDFLAGS']}'\"'", env: env
    bundle "install --without development", env: env
    rake "gem", env: env
  end

  delete "pkg/ohai-*-x86-mingw32.gem"

  # Appbuilder in ChefDK needs to not have ohai installed in +/opt/chef/bin+
  if project.name == "chefdk"
    gem "install pkg/ohai*.gem" \
        " --no-ri --no-rdoc", env: env
  else
    gem "install pkg/ohai*.gem" \
        " --bindir '#{dest_dir}/#{install_dir}/bin'" \
        " --no-ri --no-rdoc", env: env
  end
end
