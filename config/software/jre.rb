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

name "jre"
default_version "7u3-b04"

dependency "rsync"

whitelist_file "jre/bin/javaws"
whitelist_file "jre/bin/policytool"
whitelist_file "jre/lib"
whitelist_file "jre/plugin"

# To update version visit downloads page:
# http://www.oracle.com/technetwork/java/javase/downloads/index.html
# and find version from jre downloads:
# http://www.oracle.com/technetwork/java/javase/downloads/jre7-downloads-1880261.html

jre_dl_url = 'http://www.oracle.com/technetwork/java/javase/downloads/jre7-downloads-1880261.html'
jre_ver_major = 7
jre_ver_update = 55
jre_ver_build = 13
jre_ver = "#{jre_ver_major}u#{jre_ver_update}"
jre_dir = "#{jre_ver}-b#{jre_ver_build}"

if Ohai.kernel['machine'] =~ /x86_64/
  # TODO: download x86 version on x86 machines


  source :url => "http://download.oracle.com/otn-pub/java/jdk/#{jre_dir}/jre-#{jre_ver}-linux-x64.tar.gz",
         :md5 => "5dea1a4d745c55c933ef87c8227c4bd5",
         :cookie => "oraclelicense=accept-securebackup-cookie; gpw_e24=#{jre_dl_url}",
         :warning => "By including the JRE, you accept the terms of the Oracle Binary Code License Agreement for the Java SE Platform Products and JavaFX, which can be found at http://www.oracle.com/technetwork/java/javase/terms/license/index.html"
else
  source :url => "http://download.oracle.com/otn-pub/java/jdk/#{jre_dir}/jre-#{jre_ver}-linux-i586.tar.gz",
         :md5 => "9e363fb6fdd072d04aa5862a8e06e6c2",
         :cookie => "oraclelicense=accept-securebackup-cookie; gpw_e24=#{jre_dl_url}",
         :warning => "By including the JRE, you accept the terms of the Oracle Binary Code License Agreement for the Java SE Platform Products and JavaFX, which can be found at http://www.oracle.com/technetwork/java/javase/terms/license/index.html"
end

relative_path "jre1.#{jre_ver_major}.0_#{"%02d" % jre_ver_update}"

jre_dir = "#{install_dir}/embedded/jre"

build do
  command "mkdir -p #{jre_dir}"
  command "#{install_dir}/embedded/bin/rsync -a . #{jre_dir}/"
end
