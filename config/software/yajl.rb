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

name "yajl"
gem_version = "1.1.0"

dependency "rubygems"

relative_path "yajl-ruby"

if (platform == "solaris2" and Omnibus.config.solaris_compiler == "studio")
  version "sparc"
  source :git => "git://github.com/Atalanta/yajl-ruby"

  build do
    gem "build yajl-ruby.gemspec"
    gem ["install yajl-ruby-#{gem_version}.gem",
         "-n #{install_dir}/bin",
         "--no-rdoc --no-ri"].join(" ")
  end
else
  version "1.1.0"
  build do
    gem ["install yajl-ruby",
         "-v #{gem_version}",
         "-n #{install_dir}/bin",
         "--no-rdoc --no-ri"].join(" ")
  end
end
