#
# Copyright 2015 Chef Software, Inc.
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

name "ibm-jre"

if ppc64?
  jre_installer = 'ibm-java-ppc64-jre-8.0-0.0.bin'
  app_version = "ppc64-8.0-0.0"
elsif ppc64le?
  jre_installer = 'ibm-java-ppc64le-jre-8.0-0.0.bin'
  app_version = "ppc64le-8.0-0.0"
end

default_version app_version

raise "IBM-jre can only be installed on ppc64 systems." unless _64_bit?

whitelist_file "jre/bin/javaws"
whitelist_file "jre/bin/policytool"
whitelist_file "jre/lib"
whitelist_file "jre/plugin"
whitelist_file "jre/bin/appletviewer"

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

  # ensure previously installed IBM jre is cleaned up if any.
  rpm_name = jre_installer.gsub(/bin$/, ppc64? ? "ppc64" : "ppc64le") unless jre_installer.nil?
  command "sudo rpm -e #{rpm_name} 2>/dev/null || true"
  command "sudo rm -f /var/.com.zerog.registry.xml"

  # Installer needs sudo, mostly since it creates /var/.com.zerog.registry.xml
  command "chmod +x #{jre_installer}"
  command "sudo ./#{jre_installer} -i silent -DUSER_INSTALL_DIR=#{install_dir}/embedded/jre"
  command "sudo chown -R $(whoami) #{install_dir}/embedded/jre"
end

