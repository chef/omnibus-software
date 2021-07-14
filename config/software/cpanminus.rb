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

# version_list: url=https://github.com/miyagawa/cpanminus/releases filter=*.tar.gz

version("1.9019") { source sha256: "d0a37547a3c4b6dbd3806e194cd6cf4632158ebed44d740ac023e0739538fb46" }
version("1.7004") { source sha256: "5cef499d12418a877c68070fc14193bd700d47a286d95e16c517f9673493af79" }

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

