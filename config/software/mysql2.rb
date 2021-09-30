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

#
# Enable MySQL support by adding the following to '/etc/chef-server/chef-server.rb':
#
#   database_type = 'mysql'
#   postgresql['enable'] = false
#   mysql['enable'] = true
#   mysql['destructive_migrate'] = true
#
# Then run 'chef-server-ctl reconfigure'
#

versions_to_install = ["0.3.6", "0.3.7"]

name "mysql2"
default_version versions_to_install.join("-")

dependency "ruby"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  cache_path = "#{install_dir}/embedded/service/gem/ruby/1.9.1/cache"

  gem "install rake-compiler" \
      " --version '0.8.3'" \
      "  --no-document", env: env

  mkdir cache_path

  versions_to_install.each do |version|
    gem "fetch mysql2" \
        " --version '#{version}'", env: env, cwd: cache_path
  end
end
