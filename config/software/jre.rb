#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
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
version "7u2-b13"

dependencies ["rsync"]

# TODO: download x86 version on x86 machines
source :url => "http://download.oracle.com/otn-pub/java/jdk/7u2-b13/jdk-7u2-linux-x64.tar.gz",
       :md5 => "a0bbb9265b4633cfd7823928649f450c"

relative_path "jdk1.7.0_02"

jre_dir = "#{install_dir}/embedded/jre"

build do
  command "mkdir -p #{jre_dir}"
  command "#{install_dir}/embedded/bin/rsync -a jre/ #{jre_dir}/"
end
