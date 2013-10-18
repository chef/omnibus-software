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

version ENV["OHAI_GIT_REV"] || "master"

source :git => "git://github.com/opscode/ohai"

relative_path "ohai"

always_build true

env =
  case platform
  when "solaris2"
    if Omnibus.config.solaris_compiler == "studio"
    {
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
    }
    elsif Omnibus.config.solaris_compiler == "gcc"
    {
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc",
      "LD_OPTIONS" => "-R#{install_dir}/embedded/lib"
    }
    else
      raise "Sorry, #{Omnibus.config.solaris_compiler} is not a valid compiler selection."
    end
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

  # install chef first so that ohai gets installed into /opt/chef/bin/ohai
  rake "gem", :env => env.merge({"PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"})

  gem ["install pkg/ohai*.gem",
      "-n #{install_dir}/bin",
      "--no-rdoc --no-ri"].join(" "), :env => env.merge({"PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"})

end
