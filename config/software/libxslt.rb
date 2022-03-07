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

name "libxslt"
default_version "1.1.28"

dependency "libxml2"
dependency "libtool" if ohai["platform"] == "solaris2"
dependency "liblzma"
dependency "config_guess"

version "1.1.26" do
  source sha256: "55dd52b42861f8a02989d701ef716d6280bfa02971e967c285016f99c66e3db1"
end

version "1.1.28" do
  source sha256: "5fc7151a57b89c03d7b825df5a0fae0a8d5f05674c0e7cf2937ecec4d54a028c"
end

source url: "ftp://xmlsoft.org/libxml2/libxslt-#{version}.tar.gz"

relative_path "libxslt-#{version}"

build do
  env = {
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
  }

  update_config_guess

  command(["./configure",
           "--prefix=#{install_dir}/embedded",
           "--with-libxml-prefix=#{install_dir}/embedded",
           "--with-libxml-include-prefix=#{install_dir}/embedded/include",
           "--with-libxml-libs-prefix=#{install_dir}/embedded/lib",
           "--without-python",
           "--without-crypto"].join(" "),
    env: env)
  command "make -j #{workers}", env: { "LD_RUN_PATH" => "#{install_dir}/embedded/bin" }
  command "make install", env: { "LD_RUN_PATH" => "#{install_dir}/embedded/bin" }
end
