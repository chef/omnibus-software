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

name "perl_pg_driver"
default_version "3.14.2"

dependency "perl"
dependency "cpanminus"
dependency "postgresql"

license "Artistic"
license_file "README"
license_file "LICENSES/artistic.txt"

# version_list: url=https://cpan.metacpan.org/authors/id/T/TU/TURNSTEP/ filter=*.tar.gz

version("3.14.2") { source md5: "6b8fe657f8cc0be8cc2c178f42c1d4ed" }
version("3.5.3")  { source md5: "21cdf31a8d1f77466920375aa766c164" }
version("3.3.0")  { source md5: "547de1382a47d66872912fe64282ff55" }

source url: "http://search.cpan.org/CPAN/authors/id/T/TU/TURNSTEP/DBD-Pg-#{version}.tar.gz"

relative_path "DBD-Pg-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "cpanm -v --notest .", env: env
end
