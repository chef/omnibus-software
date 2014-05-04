#
# Copyright:: Copyright (c) 2014 Chef Software, Inc.
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

name "relx"

# Release tags are available, which you can use via override in
# project config.
default_version "master"

dependency "erlang"

# NOTE: requires rebar > 2.2.0 Not sure what the minimum is, but
# 837df640872d6a5d5d75a7308126e2769d7babad of rebar works.
dependency "rebar"

source :git => "https://github.com/erlware/relx.git"

relative_path "relx"

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}",
  "LD_FLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  command "make", :env => env
  command "cp ./relx #{install_dir}/embedded/bin/"
end
