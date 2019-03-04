#
# Copyright 2014 Chef Software, Inc.
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

name "highline-gem"
default_version "1.6.21"

license "Ruby"
license_file "https://raw.githubusercontent.com/JEG2/highline/master/LICENSE"
license_file "http://www.ruby-lang.org/en/LICENSE.txt"
# highline does not have any dependencies. We only install it from
# rubygems here.
skip_transitive_dependency_licensing true

dependency "ruby"
dependency "rubygems"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  gem "install highline" \
      " --version '#{version}'" \
      " --bindir '#{install_dir}/embedded/bin'" \
      "  --no-document", env: env
end
