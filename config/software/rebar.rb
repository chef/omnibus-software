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
# expeditor/ignore: no version pinning

name "rebar"

# Current version (2.3.0) suffers from a pretty bad bug that breaks tests.
# (see https://github.com/rebar/rebar/pull/279 and https://github.com/rebar/rebar/pull/251)
# Version 2.3.1 Fixes this; we should switch to that if later versions aren't workable.
# Version 2.6.1 includes this fix.
default_version "93621d0d0c98035f79790ffd24beac94581b0758"

license "Apache-2.0"
license_file "LICENSE"

version "2.6.0"

dependency "erlang"

source git: "https://github.com/rebar/rebar.git"

relative_path "rebar"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./bootstrap", env: env
  copy "#{project_dir}/rebar", "#{install_dir}/embedded/bin/"
end
