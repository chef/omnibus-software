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
name "fontconfig"
version "2.4.2"

dependency "freetype"

source :url => "http://oss.oetiker.ch/rrdtool/pub/libs/fontconfig-#{version}.tar.gz",
       :md5 => "f035852f521b54677f2b5c9e2f6d54a4"

relative_path "fontconfig-#{version}"

env = {
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
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
            "--with-freetype-config=#{install_dir}/embedded/bin/freetype-config",
           ].join(" "), :env => env

  command "make -j #{max_build_jobs}", :env => env
  command "make install", :env => env
end
