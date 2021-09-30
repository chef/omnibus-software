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

# Oracle doesn't distribute JRE builds for ARM, only JDK
# builds. Since we do no want to ship a larger package with a
# different layout, we just pick the 'jre' folder inside the jdk.
# This allows us to get as close as an ARM JRE package as we can.
#
# expeditor/ignore: deprecated 2021-04

name "jre-from-jdk"
default_version "8u91"

unless _64_bit? || armhf?
  raise "The 'jre-from-jdk' can only be installed on armhf and x86_64"
end

license "Oracle-Binary"
license_file "LICENSE"
skip_transitive_dependency_licensing true

whitelist_file "jre/bin/javaws"
whitelist_file "jre/bin/policytool"
whitelist_file "jre/lib"
whitelist_file "jre/plugin"
whitelist_file "jre/bin/appletviewer"

license_warning = "By including the JRE, you accept the terms of the Oracle Binary Code License Agreement for the Java SE Platform Products and JavaFX, which can be found at http://www.oracle.com/technetwork/java/javase/terms/license/index.html"
license_cookie = "gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"

version "8u91" do
  # https://www.oracle.com/webfolder/s/digest/8u91checksum.html
  if armhf?
    file = "jdk-8u91-linux-arm32-vfp-hflt.tar.gz"
    md5 = "1dd3934a493b474dd79b50adbd6df6a2"
  else
    file = "jdk-8u91-linux-x64.tar.gz"
    md5 = "3f3d7d0cd70bfe0feab382ed4b0e45c0"
  end

  source url: "http://download.oracle.com/otn-pub/java/jdk/8u91-b14/#{file}",
         md5: md5,
         cookie: license_cookie,
         warning: license_warning,
         unsafe: true

  relative_path "jdk1.8.0_91"
end

build do
  mkdir "#{install_dir}/embedded/jre"

  sync  "#{project_dir}/jre", "#{install_dir}/embedded/jre"
end
