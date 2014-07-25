#
# Copyright 2014 Chef Software, Inc.omnibus
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

name "expat"
default_version "2.1.0"

relative_path "expat-2.1.0"

source url: "http://downloads.sourceforge.net/project/expat/expat/2.1.0/expat-2.1.0.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fexpat%2F&ts=1374730265&use_mirror=iweb",
       md5: "dd7dab7a5fea97d2a6a43f511449b7cd"

build do
  env = with_standard_compiler_flags

  command "./configure" \
          " --prefix=#{install_dir}/embedded", env: env

  command "make -j #{max_build_jobs}", env: env
  command "make install"
end
