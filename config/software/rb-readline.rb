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

name "rb-readline"
default_version "master"

# This is only used when we compile our own ruby.
# Pre-built rubies come with their own readline/libedit.
dependency "ruby-compiled"

source git: "https://github.com/ConnorAtherton/rb-readline.git"

build do
  env = with_embedded_path

  ruby "setup.rb", env: env
end
