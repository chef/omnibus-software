#
# Copyright 2012-2014 Chef Software, Inc.
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

name "config-guess"
default_version "master"

version "master"

source git: "http://git.savannah.gnu.org/r/config.git"

relative_path "config-guess"

build do
  copy "config-guess/config.guess", "#{Omnibus::Config.source_dir}/config-guess/config.guess"
  copy "config-guess/config.sub", "#{Omnibus::Config.source_dir}/config-guess/config.sub"
end
