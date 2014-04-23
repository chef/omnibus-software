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
name "cairo"
version "1.6.4"

dependency "pixman"

source :url => "http://oss.oetiker.ch/rrdtool/pub/libs/cairo-#{version}.tar.gz",
       :md5 => "a198d509f9e3a35b78de8bb02174ebb9"

relative_path "cairo-#{version}"

env = {
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "CXXFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "CPPFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
    "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}",
    "PKG_CONFIG_PATH" => "#{install_dir}/embedded/lib/pkgconfig",
    #"pixman_CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    #"pixman_LIBS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
}

build do
  command [
            "./configure",
            "--prefix=#{install_dir}/embedded",
            "--enable-xlib=no",
            "--enable-xlib-render=no",
            "--enable-win32=no",
           ].join(" "), :env => env

  command "make -j #{max_build_jobs}", :env => env
  command "make install", :env => env
end
