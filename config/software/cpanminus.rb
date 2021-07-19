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
default_version "1.9011"

license "Artistic-2.0"
license_file "http://dev.perl.org/licenses/artistic.html"
skip_transitive_dependency_licensing true

dependency "perl"

# version_list: url=https://github.com/miyagawa/cpanminus/releases filter=*.tar.gz

version("1.9011") { source sha256: "d708ef86a23b6bc4f3f961513e1eb3827e6e75f390849b1d5bc777d79bfb4a74" }
version("1.7040") { source sha256: "48a747c040689445f7db0edd169da0abd709a37cfece3ceecff0816c09beab0e" }

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