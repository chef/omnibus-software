#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
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

name "chefdk"

if platform == 'windows'
  dependency "chef-windows"
else
  dependency "chef"
end
dependency "berkshelf"

env = {
  # rubocop pulls in nokogiri 1.5.11, so needs PKG_CONFIG_PATH and
  # NOKOGIRI_USE_SYSTEM_LIBRARIES until rubocop stops doing that
  "PKG_CONFIG_PATH" => "#{install_dir}/embedded/lib/pkgconfig",
  "NOKOGIRI_USE_SYSTEM_LIBRARIES" => "true",
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}

build do
  auxiliary_gems = []

  auxiliary_gems << "test-kitchen"
  auxiliary_gems << "foodcritic"
  auxiliary_gems << "chefspec"
  auxiliary_gems << "rubocop"
# strainer build is hosed on windows
#  auxiliary_gems << "strainer"
  auxiliary_gems << "knife-spork"

  # do multiple gem installs to better isolate/debug failures
  auxiliary_gems.each do |gem|
    gem ["install",
         gem,
         "-n #{install_dir}/bin",
         "--no-rdoc --no-ri"].join(" "), :env => env
  end
end

