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

name "liblzma"
default_version "5.0.5"

source url: "https://tukaani.org/xz/xz-#{version}.tar.gz",
       sha256: "5dcffe6a3726d23d1711a65288de2e215b4960da5092248ce63c99d50093b93a"

relative_path "xz-#{version}"

build do
  license "Public-Domain"

  cmd = [ "./configure",
          "--prefix=#{install_dir}/embedded",
          "--disable-debug",
          "--disable-dependency-tracking"].join(" ")

  env = {
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
  }

  command cmd, env: env
  command "make install", env: env
end
