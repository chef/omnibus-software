#
# Copyright 2012-2016 Chef Software, Inc.
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

# Vendors our custom mingw/msys compiler environment along with the latest
# rubygems.
# Do no depend on this software definition directly. You probably want to
# include rubygems-native instead.
#
# TODO: We don't currently vendor any implementation of tar. Do that either
# here or as part of the mingw software definition.

name "rubygems-mingw"
default_version "0.0.1"

dependency "ruby"
dependency "rubygems"
dependency "mingw"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  erb source: 'register_devtools.rb.erb', dest: "#{project_dir}/register_devtools.rb",
    vars: { paths: [ "#{install_dir}/embedded/bin", "#{install_dir}/embedded/msys/1.0/bin" ] }
  ruby "register_devtools.rb", env: env
end
