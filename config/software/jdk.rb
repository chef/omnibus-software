#
# Copyright:: Copyright (c) 2013 Robby Dyer
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
name "jdk"
version "7u40-b43"

dependency "rsync"

whitelist_file "jdk/bin/javaws"
whitelist_file "jdk/bin/policytool"
whitelist_file "jdk/bin/appletviewer"
whitelist_file "jdk/lib"
whitelist_file "jdk/plugin"
whitelist_file "jdk/jre/bin/javaws"
whitelist_file "jdk/jre/bin/policytool"
whitelist_file "jdk/jre/lib"
whitelist_file "jdk/jre/plugin"

if OHAI.kernel['machine'] =~ /x86_64/
  source :url => "http://download.oracle.com/otn-pub/java/jdk/7u40-b43/jdk-7u40-linux-x64.tar.gz",
         :md5 => "511ea34e4a42955bc03c28afa4b8f6cf",
         ## Cookie fakery needed, because Oracle sucks balls
         :cookie => 'oraclelicensejdk-7u40-oth-JPR=accept-securebackup-cookie;gpw_e24=http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html'
else
  source :url => "http://download.oracle.com/otn-pub/java/jdk/7u40-b43/jdk-7u40-linux-i586.tar.gz",
         :md5 => "",
         ## Once again, cookie fakery needed, because Oracle sucks balls
         :cookie => 'oraclelicensejdk-7u40-oth-JPR=accept-securebackup-cookie;gpw_e24=http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html'
end

relative_path "jdk1.7.0_40"

jdk_dir = "#{install_dir}/embedded/jdk"

build do
  command "mkdir -p #{jdk_dir}"
  command "#{install_dir}/embedded/bin/rsync -a . #{jdk_dir}/"
end
