#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
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

name "cacerts"
version "2012.12.19"  # date of the file is in a comment at the start

source :url => "http://curl.haxx.se/ca/cacert.pem",
       :md5 => '47961e7ef15667c93cd99be01b51f00a'

relative_path "cacerts-#{version}"

build do
  command "mkdir -p /opt/chef/embedded/ssl/certs"
  command "cp cacert.pem #{install_dir}/embedded/ssl/certs/cacert.pem"
  command "ln -sf #{install_dir}/embedded/ssl/certs/cacert.pem #{install_dir}/embedded/ssl/cert.pem"
end
