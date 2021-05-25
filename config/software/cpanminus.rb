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

name "cpanminus"
default_version "1.7004"

license "Artistic-2.0"
license_file "http://dev.perl.org/licenses/artistic.html"
skip_transitive_dependency_licensing true

dependency "perl"

version "1.7040" do
  source md5: "4fabebffe22eaaf584b345b082a8a9c1"
end

version "1.7004" do
  source md5: "02fe90392f33a12979e188ea110dae67"
end

source url: "https://github.com/miyagawa/cpanminus/archive/#{version}.tar.gz"

relative_path "cpanminus-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "cat cpanm | perl - App::cpanminus", env: env
end

# Perl after 5.18 does not come with this by default
build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "cpanm Module::Build", env: env
end

