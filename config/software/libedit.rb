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

name "libedit"
version "20120601-3.0"

dependency "ncurses"

source :url => "http://www.thrysoee.dk/editline/libedit-20120601-3.0.tar.gz",
       :md5 => "e50f6a7afb4de00c81650f7b1a0f5aea"

relative_path "libedit-20120601-3.0"

env = {
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -I#{install_dir}/embedded/include/ncurses",
    "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -I#{install_dir}/embedded/include/ncurses",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
    "LD_OPTIONS" => "-R#{install_dir}/embedded/lib"
  }

case platform
when "freebsd"
  make = "gmake"
else
  make = "make"
end

build do
  if platform == "freebsd"
    patch :source => "freebsd-vi-fix.patch"
  end
  command ["./configure",
           "--prefix=#{install_dir}/embedded"
           ].join(" "), :env => env
  command "#{make}", :env => env
  command "#{make} install"
end
