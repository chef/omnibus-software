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
# expeditor/ignore: deprecated 2021-04

name "ibm-jre"

license "IBM-Java-contractual-redistribution"
# This license is stange, it says it cannot be redistributed but Chef has obtained
# a contractual agreement with IBM to repackange and redistribute the JRE free of
# charge and without support or warranty to our mutual customers
license_file "copyright"
license_file "license_en.txt"
skip_transitive_dependency_licensing true

if ppc64?
  source url: "https://s3.amazonaws.com/chef-releng/java/jre/ibm-java-ppc64-80.tar.xz",
         md5: "face417c3786945c2eb458f058b8616b"
  app_version = "ibm-java-ppc64-80"
  relative_path "ibm-java-ppc64-80"
elsif ppc64le?
  source url: "https://s3.amazonaws.com/chef-releng/java/jre/ibm-java-ppc64le-80.tar.xz",
         md5: "199e3f1b5e3035bc813094e2973ffafb"
  app_version = "ibm-java-ppc64le-80"
  relative_path "ibm-java-ppc64le-80"
elsif s390x?
  source url: "https://s3.amazonaws.com/chef-releng/java/jre/ibm-java-s390x-80.tar.gz",
         md5: "722bf5ab5436add5fdddbed4b07503c7"
  app_version = "ibm-java-s390x-80"
  relative_path "ibm-java-s390x-80"
else
  puts "The IBM JRE support for this platform was not found, thus it will not be installed"
end

default_version app_version

whitelist_file "jre/bin/javaws"
whitelist_file "jre/bin/policytool"
whitelist_file "jre/lib"
whitelist_file "jre/plugin"
whitelist_file "jre/bin/appletviewer"
whitelist_file "jre/bin/unpack200"

build do
  mkdir "#{install_dir}/embedded/jre"
  sync  "#{project_dir}/jre/", "#{install_dir}/embedded/jre"
end
