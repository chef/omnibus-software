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

name "postgresql"
default_version "9.4.25"

dependency "zlib"
dependency "openssl" # openssl >= 1.1 is compatible with postgresql >=9.4
dependency "libedit"
dependency "ncurses"

version "9.1.9" do
  source sha256: "28a533e181009308722e8b3c51f1ea7224ab910c380ac1a86f07118667602dd8"
end

version "9.2.8" do
  source sha256: "568ba482340219097475cce9ab744766889692ee7c9df886563e8292d66ed87c"
end

version "9.3.4" do
  source sha256: "9ee819574dfc8798a448dc23a99510d2d8924c2f8b49f8228cd77e4efc8a6621"
end

# Version lower than 9.4 aren't compatible with openssl 1.1
# (9.4.12 for openssl 1.1.0 and 9.4.24 for visual studio)
version "9.4.25" do
  source sha256: "cb98afaef4748de76c13202c14198e3e4717adde49fd9c90fdc81da877520928"
end

source url: "https://ftp.postgresql.org/pub/source/v#{version}/postgresql-#{version}.tar.bz2"
relative_path "postgresql-#{version}"

configure_env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
}

build do
  command ["./configure",
           "--prefix=#{install_dir}/embedded",
           "--with-libedit-preferred",
           "--with-openssl --with-includes=#{install_dir}/embedded/include",
           "--with-libraries=#{install_dir}/embedded/lib"].join(" "), env: configure_env
  command "make -j #{workers}", env: { "LD_RUN_PATH" => "#{install_dir}/embedded/lib" }
  command "make install"
end
