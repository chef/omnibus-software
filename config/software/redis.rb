#
# Copyright:: Copyright (c) 2012-2014 Chef Software, Inc.
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

name "redis"
default_version "2.8.2"

version "2.8.2" do
  source sha256: "8e46ab9916e308210255e33465f8021c6ebb1ff3f545cff141e36a9a10edaec7"
end

version "2.4.7" do
  source sha256: "f91956377b7ff23cc23e0c8758e0b873032f36545c61d88436ebb741bf4dd5e1"
end

source url: "https://download.redis.io/releases/redis-#{version}.tar.gz"
relative_path "redis-#{version}"

make_args = ["PREFIX=#{install_dir}/embedded",
             "CFLAGS='-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include'",
             "LD_RUN_PATH=#{install_dir}/embedded/lib"].join(" ")

build do
  command ["make -j #{workers}", make_args].join(" ")
  command ["make install", make_args].join(" ")
end
