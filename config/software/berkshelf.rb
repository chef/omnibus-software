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

source :git => "git://github.com/berkshelf/berkshelf"

relative_path "berkshelf"
always_build true

if platform == 'windows'
  dependency "ruby-windows"
  dependency "ruby-windows-devkit"
else
  dependency "libffi" if version.to_f > 3.0
  dependency "ruby"
  dependency "rubygems"
end
dependency "nokogiri"
dependency "libarchive"

build do
  bundle "install --without guard", :env => {"PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"}
  bundle "exec thor gem:build", :env => {"PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"}
  gem ["install pkg/berkshelf-*.gem",
       "--no-rdoc --no-ri"].join(" "), :env => {"PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"}
end
