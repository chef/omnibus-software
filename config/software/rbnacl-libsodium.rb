#
# Copyright 2012-2017 Chef Software, Inc.
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

name "rbnacl-libsodium"
default_version "1.0.11"
relative_path "rbnacl-libsodium"

source git: "https://github.com/cryptosphere/rbnacl-libsodium.git"

license "MIT"
license_file "LICENSE"

dependency "ruby"
dependency "rubygems"
dependency "bundler"

build do
  env = with_embedded_path()

  bundle "install --without development_extras", env: env
  bundle "exec rake gem", env: env

  delete "pkg/*java*"

  gem "install pkg/rbnacl-libsodium-*.gem" \
      " --no-ri --no-rdoc", env: env
end
