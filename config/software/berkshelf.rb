#
# Copyright:: Copyright (c) 2012-2014 Chef Software, Inc.
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

name "berkshelf"
default_version "master"
always_build true

source :git => "git://github.com/berkshelf/berkshelf"

relative_path "berkshelf"

if platform == 'windows'
  dependency "ruby-windows"
  dependency "ruby-windows-devkit"
else
  dependency "libffi"
  dependency "ruby"
  dependency "rubygems"
  dependency "libarchive"
end
dependency "nokogiri"

dependency "bundler"

build do
  # determine correct path variable for windows, can be PATH or Path
  path_key = ENV.keys.grep(/\Apath\Z/i).first
  current_path = ENV[path_key]

  bundle "install --without guard", :env => {path_key => path_with_embedded }
  bundle "exec thor gem:build", :env => {path_key => path_with_embedded }
  gem ["install pkg/berkshelf-*.gem",
       "--no-rdoc --no-ri"].join(" "), :env => {path_key => path_with_embedded }
end
