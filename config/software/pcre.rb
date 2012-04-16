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

name "pcre"
version "8.30"

dependencies ["readline", "ncurses"]

source :url => "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.30.tar.gz",
       :md5 => "d5ee0d9f6d2f0b7489331d04b6c182ef"

relative_path "pcre-8.30"

build do
  command("./configure --prefix=#{install_dir}/embedded",
          :env => {
            "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
          })
  # command "touch alocal.m4"
  command("make -j #{max_build_jobs}",
          :env => {
            "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}"
          })
  command "make install"
end
