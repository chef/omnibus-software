#
# Copyright:: Copyright (c) 2015.
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

name "wildfly"
default_version "10.1.0.Final"

version "10.1.0.Final" do
  source md5: "d49d042509d51713038394715b8480ab"
end

version "8.2.1.Final" do
  source md5: "8e784c2759f3eeab516b3ec2a23a2246"
end

version "8.1.0.Final" do
  source md5: "46caf74201245742a99f8a3eaac7e647"
end

source url: "http://download.jboss.org/wildfly/#{version}/wildfly-#{version}.tar.gz"
# Resolve wildfly broken tag.gz 30-11-2016
# source url: "http://ups.c-b4.com/wildfly/#{version}/wildfly-#{version}.tar.gz"

relative_path "wildfly-#{version}"

build do
  env = with_standard_compiler_flags

  command "mkdir -p #{install_dir}/embedded/apps/wildfly"

  # Wildfly.tar.gz is copied and not extracted due to libHornetQAIO64.so missing dep:
  # DEPENDS ON: libaio.so.1
  copy "#{Omnibus::Config.cache_dir}/wildfly-#{version}.tar.gz",      "#{install_dir}/embedded/apps/wildfly/"
end
