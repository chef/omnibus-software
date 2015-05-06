#
# Copyright 2013-2014 Chef Software, Inc.
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

name "server-jre"

app_version = if ppc64?
  jre_installer = 'ibm-java-ppc64-jre-8.0-0.0.bin'
  "ppc64-8.0-0.0"
elsif ppc64le?
  jre_installer = 'ibm-java-ppc64le-jre-8.0-0.0.bin'
  "ppc64le-8.0-0.0"
else
  "8u31"
end

default_version app_version

raise "Server-jre can only be installed on x86_64 or ppc64 systems." unless _64_bit?

whitelist_file "jre/bin/javaws"
whitelist_file "jre/bin/policytool"
whitelist_file "jre/lib"
whitelist_file "jre/plugin"
whitelist_file "jre/bin/appletviewer"

version "8u31" do
  source url:     "http://download.oracle.com/otn-pub/java/jdk/8u31-b13/server-jre-8u31-linux-x64.tar.gz",
         md5:     "9d69cdc00c536b8c9f5b26a3128bd2a1",
         cookie:  "gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie",
         warning: "By including the JRE, you accept the terms of the Oracle Binary Code License Agreement for the Java SE Platform Products and JavaFX, which can be found at http://www.oracle.com/technetwork/java/javase/terms/license/index.html",
         unsafe:  true
  relative_path "jdk1.8.0_31"
end

version "7u25" do
  source url:     "http://download.oracle.com/otn-pub/java/jdk/7u25-b15/server-jre-7u25-linux-x64.tar.gz",
         md5:     "7164bd8619d731a2e8c01d0c60110f80",
         cookie:  "gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie",
         warning: "By including the JRE, you accept the terms of the Oracle Binary Code License Agreement for the Java SE Platform Products and JavaFX, which can be found at http://www.oracle.com/technetwork/java/javase/terms/license/index.html",
         unsafe:  true
  relative_path "jdk1.7.0_25"
end

version "ppc64-8.0-0.0" do
  # TODO - replace temp url
  source url: "https://www.dropbox.com/s/trdbu99ywx730be/ibm-java-ppc64-jre-8.0-0.0.bin?dl=1",
         md5: "5d51a9f70123dfcebc606d6e3e334946"
  relative_path "ibmjre-8.0-0.0"
end

version "ppc64le-8.0-0.0" do
  # TODO - replace temp url
  source url: "https://www.dropbox.com/s/of8mcol4vyb3w08/ibm-java-ppc64le-jre-8.0-0.0.bin?dl=1",
         md5: "a8a6c6708a361d4edc8e475ee63fdda7"
  relative_path "ibmjre-8.0-0.0"
end


build do
  mkdir "#{install_dir}/embedded/jre"

  if ppc64? || ppc64le?
    command "chmod +x #{jre_installer}"
    # Installer needs sudo, mostly since it creates /var/.com.zerog.registry.xml
    command "sudo ./#{jre_installer} -i silent -DUSER_INSTALL_DIR=#{install_dir}/embedded/jre"
    command "sudo chown -R $(whoami) #{install_dir}/embedded/jre"
  else
    sync  "#{project_dir}/", "#{install_dir}/embedded/jre"
  end
end
