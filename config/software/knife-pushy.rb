#
# Copyright:: Copyright (c) 2013 Opscode, Inc.
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

name "knife-pushy"

dependency "chef"

version "master"

always_build true

# TODO - use public GIT URL when repo made public
source :git => "git@github.com:opscode/knife-pushy.git"

relative_path "knife-pushy"

env =
  case platform
  when "solaris2"
    {
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc",
      "LD_OPTIONS" => "-R#{install_dir}/embedded/lib"
    }
  else
    {
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-Wl,-rpath #{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
    }
  end

env.merge!({"PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"})

build do
  rake "build", :env => env

  gem ["install pkg/knife-pushy*.gem",
      "-n #{install_dir}/bin",
      "--no-rdoc --no-ri"].join(" "), :env => env

  bundle "install", :env => env

end
