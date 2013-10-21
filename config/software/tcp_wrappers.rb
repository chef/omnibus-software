#
# Copyright:: Copyright (c) 2013 Robby Dyer
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
name "tcp_wrappers"
version "7.6"

source :url => "ftp://ftp.porcupine.org/pub/security/tcp_wrappers_#{version}.tar.gz",
       :md5 => "e6fa25f71226d090f34de3f6b122fb5a"

relative_path "tcp_wrappers_#{version}"

env = {
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
    "LD_LIBRARY_PATH" => "#{install_dir}/embedded/lib",
    "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}",
    "DESTDIR" => "#{install_dir}/embedded",
}

build do
    patch :source => "tcp_wrappers-7.6-shared_lib_plus_plus-1.patch"

    ## Without this, build fails on newer gcc versions
    command 'sed -i -e "s,^extern char \*malloc();,/* & */," scaffold.c'

    ## Why did they hardcode the lib destdir? Eff that, yo. 
    command 'sed -i -e "s,${DESTDIR}/usr/lib,${DESTDIR}/lib,g" Makefile'

    command "make REAL_DAEMON_DIR=#{install_dir}/embedded/sbin linux", :env => env
    command "sudo make install", :env => env

    ## This might not be needed?
    command "chmod 775 #{install_dir}/embedded/lib/libwrap.so.0.#{version}"
end
