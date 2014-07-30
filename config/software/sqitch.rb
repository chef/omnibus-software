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

name "sqitch"
default_version "0.973"

dependency "perl"
dependency "cpanminus"

source url: "http://www.cpan.org/authors/id/D/DW/DWHEELER/App-Sqitch-#{version}.tar.gz",
       md5: "0994e9f906a7a4a2e97049c8dbaef584"

relative_path "App-Sqitch-#{version}"

# See https://github.com/theory/sqitch for more
build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "perl Build.PL", env: env
  command "./Build installdeps --cpan_client 'cpanm -v --notest'", env: env
  command "./Build", env: env
  command "./Build install", env: env
end
