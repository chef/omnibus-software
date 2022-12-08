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
# expeditor/ignore: deprecated 2021-04

name "server-jre"
default_version "8u202"

unless _64_bit?
  raise "Server-jre can only be installed on x86_64 systems."
end

license "Oracle-Binary"
license_file "LICENSE"
#
# October 2016 (ssd):
# Unfortunately http://java.com/license/ redirects to https://java.com/license/
# which then redirects to http://www.oracle.com/technetwork/java/javase/terms/license/
# triggering a bad redirect error.
#
license_file "http://www.oracle.com/technetwork/java/javase/terms/license/"
skip_transitive_dependency_licensing true

whitelist_file "jre/bin/javaws"
whitelist_file "jre/bin/policytool"
whitelist_file "jre/lib"
whitelist_file "jre/plugin"
whitelist_file "jre/bin/appletviewer"

license_warning = "By including the JRE, you accept the terms of the Oracle Binary Code License Agreement for the Java SE Platform Products and JavaFX, which can be found at http://www.oracle.com/technetwork/java/javase/terms/license/index.html"
license_cookie = "gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"

# This is the final release of the Oracle Java under the 'Oracle Binary Code License Agreement'
version "8u202" do
  source url: "https://download.oracle.com/otn/java/jdk/8u202-b08/1961070e4c9b4e26a04e7f5a083f551e/server-jre-8u202-linux-x64.tar.gz",
         sha256: "61292e9d9ef84d9702f0e30f57b208e8fbd9a272d87cd530aece4f5213c98e4e",
         cookie: license_cookie,
         warning: license_warning,
         unsafe:  true
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
         authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
  relative_path "jdk1.8.0_202"
end

version "8u162" do
  # https://www.oracle.com/webfolder/s/digest/8u162checksum.html
  source url: "http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/server-jre-8u162-linux-x64.tar.gz",
         sha256: "6942684acb6001748a01fc090a18f52ebd8cbfcf7be27ec6131981906bfa8b53",
         cookie: license_cookie,
         warning: license_warning,
         unsafe:  true
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
         authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
  relative_path "jdk1.8.0_162"
end

version "8u151" do
  # https://www.oracle.com/webfolder/s/digest/8u151checksum.html
  source url: "http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/server-jre-8u151-linux-x64.tar.gz",
         sha256: "123b1d755416aa7579abc03f01ab946e612e141b6f7564130f2ada00ed913f1d",
         cookie: license_cookie,
         warning: license_warning,
         unsafe:  true
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
         authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
  relative_path "jdk1.8.0_151"
end

version "8u144" do
  # https://www.oracle.com/webfolder/s/digest/8u144checksum.html
  source url: "http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/server-jre-8u144-linux-x64.tar.gz",
         sha256: "8ba6f1c692518beb0c727c6e1fb8c30a5dfcc38f8ef9f4f7c7c114c01c747ebc",
         cookie: license_cookie,
         warning: license_warning,
         unsafe:  true
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
         authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
  relative_path "jdk1.8.0_144"
end

version "8u121" do
  # https://www.oracle.com/webfolder/s/digest/8u121checksum.html
  source url: "http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/server-jre-8u121-linux-x64.tar.gz",
         sha256: "c25a60d02475499109f2bd6aa483721462aa7bfbb86b23ca6ac59be472747e5d",
         cookie: license_cookie,
         warning: license_warning,
         unsafe:  true
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
         authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
  relative_path "jdk1.8.0_121"
end

version "8u111" do
  # https://www.oracle.com/webfolder/s/digest/8u111checksum.html
  source url: "http://download.oracle.com/otn-pub/java/jdk/8u111-b14/server-jre-8u111-linux-x64.tar.gz",
         sha256: "53442420cd9534ded4beca16c32c1d109cf5add637db764c86660c6eea1d88d4",
         cookie: license_cookie,
         warning: license_warning,
         unsafe:  true
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
         authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
  relative_path "jdk1.8.0_111"
end

version "8u91" do
  # https://www.oracle.com/webfolder/s/digest/8u91checksum.html
  source url: "http://download.oracle.com/otn-pub/java/jdk/8u91-b14/server-jre-8u91-linux-x64.tar.gz",
         md5: "c8aefc3b97328d6f5197315fa6507bbf",
         cookie: license_cookie,
         warning: license_warning,
         unsafe:  true
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
         authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
  relative_path "jdk1.8.0_91"
end

build do
  mkdir "#{install_dir}/embedded/jre"
  sync  "#{project_dir}/", "#{install_dir}/embedded/jre"
end
