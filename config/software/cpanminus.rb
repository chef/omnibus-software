#
# Copyright:: Copyright (c) 2014 Chef Software, Inc.
# License:: Apache License, Version 2.0
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

dependency "perl"

source url: "https://github.com/miyagawa/cpanminus/archive/#{version}.tar.gz",
       sha256: "5cef499d12418a877c68070fc14193bd700d47a286d95e16c517f9673493af79"

relative_path "cpanminus-#{version}"

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}",
}

build do
  command "cat cpanm | perl - App::cpanminus", env: env
end
