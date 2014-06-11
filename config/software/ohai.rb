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

name "ohai"
if platform == 'windows'
  dependency "ruby-windows" #includes rubygems
  dependency "ruby-windows-devkit"
else
  dependency "ruby"
  dependency "rubygems"
  dependency "yajl"
end

dependency "bundler"

default_version "master"

source :git => "git://github.com/opscode/ohai"

relative_path "ohai"

env =
  case platform
  when "solaris2"
    {
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
    }
  when "aix"
    {
      "LDFLAGS" => "-Wl,-blibpath:#{install_dir}/embedded/lib:/usr/lib:/lib -L#{install_dir}/embedded/lib",
      "CFLAGS" => "-I#{install_dir}/embedded/include"
    }
  else
    {
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-Wl,-rpath #{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
    }
  end

build do
  bundle "install --without development",  :env => {path_key => path_with_embedded}

  # install chef first so that ohai gets installed into /opt/chef/bin/ohai
  bundle "exec rake gem", :env => {path_key => path_with_embedded}

  gem ["install pkg/ohai*.gem",
      "-n #{install_dir}/bin",
      "--no-rdoc --no-ri"].join(" "), :env => {path_key => path_with_embedded}

end
