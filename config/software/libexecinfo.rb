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

name "libexecinfo"
version "1.1"

source :url => 'ftp://ftp.freebsd.org/pub/FreeBSD/ports/local-distfiles/itetcu/libexecinfo-1.1.tar.bz2',
       :md5 => '8e9e81c554c1c5d735bc877448e92b91'

relative_path "libexecinfo-1.1"

env = {
  "LIBDIR" => "#{install_dir}/embedded/lib",
  "INCLUDEDIR" => "#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
  "CFLAGS" => "-fno-omit-frame-pointer",
  "BINOWN" => "#{Process.euid}",
  "BINGRP" => "#{Process.egid}",
  "LIBOWN" => "#{Process.euid}",
  "LIBGRP" => "#{Process.egid}"
}

if platform == "solaris2"
  env.merge!({"LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc", "LD_OPTIONS" => "-R#{install_dir}/embedded/lib"})
end

build do
  patch :source => "patch-execinfo.c"
  command "make", :env => env
  command "make install", :env => env
end
