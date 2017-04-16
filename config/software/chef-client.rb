#
# Author:: Tyler Cloke (<tyler@chef.io>)
# Copyright:: Copyright (c) 2015 Chef Software, Inc.
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

# TODO Eventually replaces chef-gem.rb:
# https://github.com/chef/omnibus-software/blob/master/config/software/chef-gem.rb
# Once we are ready to float everything that uses omnibus-software on master for chef-client,
# just update omnibus-software and delete this.

# Builds chef-client gem from git and installs it.
name "chef-client"
default_version "master"

source git: "https://github.com/chef/chef"

relative_path "chef"

dependency "ruby"
dependency "rubygems"
dependency "libffi"
dependency "bundler"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # install the whole bundle first
  bundle "install --without server docgen", env: env

  gem "build chef.gemspec", env: env

  gem "install chef*.gem " \
      " --bindir '#{install_dir}/embedded/bin'" \
      " --no-ri --no-rdoc", env: env
end
