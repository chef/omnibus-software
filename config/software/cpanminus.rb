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
default_version "1.7046"

license "Artistic-2.0"
license_file "http://dev.perl.org/licenses/artistic.html"
skip_transitive_dependency_licensing true

dependency "perl"

# version_list: url=https://metacpan.org/pod/App::cpanminus filter=*.tar.gz

version("1.7046") { source sha256: "cefc58349f9f741aba82b8ed3d672265b53ca4e4183f72613fce06d6ab97d30c" }
version("1.7045") { source sha256: "f2ab7e18a695960ac07f072b369c1bf113ae278bf81aa807b3f4bdaf098df34d" }
version("1.7040") { source sha256: "48a747c040689445f7db0edd169da0abd709a37cfece3ceecff0816c09beab0e" }
version("1.7004") { source sha256: "5cef499d12418a877c68070fc14193bd700d47a286d95e16c517f9673493af79" }

source url: "https://github.com/miyagawa/cpanminus/archive/#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
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

