#
# Copyright 2012-2015 Chef Software, Inc.
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

name "net-snmp"
default_version "5.7.3"

version "5.7.3" do
  source sha256: "12ef89613c7707dc96d13335f153c1921efc9d61d3708ef09f3fc4a7014fb4f0"
end

dependency "zlib"
dependency "openssl"

source url: "https://downloads.sourceforge.net/project/net-snmp/net-snmp/#{version}/net-snmp-#{version}.tar.gz",
       extract: :seven_zip

relative_path "net-snmp-#{version}"

build_env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib",
  "CFLAGS" => "-I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
  "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}",
}

net_snmp_configure = ["./configure",
                      "--with-defaults",
                      "--prefix=#{install_dir}/embedded",
                      "--with-ldflags=-L#{install_dir}/embedded/lib",
                      "--with-cflags=-I#{install_dir}/embedded/include",
                      "--with-zlib=#{install_dir}/embedded/lib",
                      "--libdir=#{install_dir}/embedded/lib",
                      "--disable-embedded-perl",
                      "--without-perl-modules",
                      "--enable-shared",
                      "--enable-static"]
build do
  ship_license "https://gist.githubusercontent.com/truthbk/219266c31f7d664c749dba525eb8a7b0/raw/82539d51d5b1e545e1ceb241b25f476956b636f9/net-snmp.license"
  command net_snmp_configure.join(" "), :env => build_env
  command "make -j #{workers}", :env => build_env
  command "make install"
end
