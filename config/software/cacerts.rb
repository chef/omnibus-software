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

name "cacerts"

license "MPL-2.0"
license_file "https://www.mozilla.org/media/MPL/2.0/index.815ca599c9df.txt"
skip_transitive_dependency_licensing true

default_version "2018-03-07"

source url: "https://curl.haxx.se/ca/cacert-#{version}.pem"

version("2018-03-07") { source sha256: "79ea479e9f329de7075c40154c591b51eb056d458bc4dff76d9a4b9c6c4f6d0b" }

version("2018-01-17") { source sha256: "defe310a0184a12e4b1b3d147f1d77395dd7a09e3428373d019bef5d542ceba3" }

version("2017-06-07") { source sha256: "e78c8ab7b4432bd466e64bb942d988f6c0ac91cd785017e465bdc96d42fe9dd0" }

version("2017-01-18") { source sha256: "e62a07e61e5870effa81b430e1900778943c228bd7da1259dd6a955ee2262b47" }

version("2016-04-20") { source sha256: "2c6d4960579b0d4fd46c6cbf135545116e76f2dbb7490e24cf330f2565770362" }

version "2016.01.20" do
  source sha256: "674f211b2a5898f2740ea62f3003ce817cdbf5f00325ab3169b7bb9922fc7808"
  source url: "https://curl.haxx.se/ca/cacert-2016-01-20.pem"
end

relative_path "cacerts-#{version}"

build do
  mkdir "#{install_dir}/embedded/ssl/certs"

  copy "#{project_dir}/cacert*.pem", "#{install_dir}/embedded/ssl/certs/cacert.pem"
  copy "#{project_dir}/cacert*.pem", "#{install_dir}/embedded/ssl/cert.pem" if windows?

  # Windows does not support symlinks
  unless windows?
    link "certs/cacert.pem", "#{install_dir}/embedded/ssl/cert.pem", unchecked: true

    block { File.chmod(0644, "#{install_dir}/embedded/ssl/certs/cacert.pem") }
  end
end
