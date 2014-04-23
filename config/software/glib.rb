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
name "glib"
version "2.15.4"

source :url => "http://oss.oetiker.ch/rrdtool/pub/libs/glib-#{version}.tar.gz",
       :md5 => "14c3ce0d2e9befe607bae0c514500e9e"

relative_path "glib-#{version}"

env = {
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -Wl,--rpath -Wl,${INSTALL_DIR}/lib",
    "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "CPPFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
    "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}",
    "PKG_CONFIG_PATH" => "#{install_dir}/embedded/lib/pkgconfig",
}

build do
  command [
            "./configure",
            "--prefix=#{install_dir}/embedded",
            "--with-libiconv=gnu",
            "--disable-selinux",
           ].join(" "), :env => env

  command "make -j #{max_build_jobs}", :env => env
  command "make install", :env => env
end
