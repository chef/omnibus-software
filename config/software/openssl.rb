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

name "openssl"
version "1.0.0f"

dependencies ["zlib"]

source :url => "http://www.openssl.org/source/openssl-1.0.0f.tar.gz",
       :md5 => "e358705fb4a8827b5e9224a73f442025"

relative_path "openssl-1.0.0f"

build do
  # configure
  if platform == "mac_os_x"
    command ["./Configure",
             "darwin64-x86_64-cc",
             "--prefix=#{install_dir}/embedded",
             "--with-zlib-lib=#{install_dir}/embedded/lib",
             "--with-zlib-include=#{install_dir}/embedded/include",
             "zlib",
             "shared"].join(" ")
  elsif platform == "freebsd"
    command(["./config",
             "--prefix=#{install_dir}/embedded",
             "--with-zlib-lib=#{install_dir}/embedded/lib",
             "--with-zlib-include=#{install_dir}/embedded/include",
             "zlib",
             "shared",
             "-L#{install_dir}/embedded/lib",
             "-I#{install_dir}/embedded/include",
             "-R#{install_dir}/embedded/lib"].join(" "),
            :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"})
  elsif platform == "solaris2"
    command ["./Configure",
             "solaris-sparcv9-cc",
             "--prefix=#{install_dir}/embedded",
             "--with-zlib-lib=#{install_dir}/embedded/lib",
             "--with-zlib-include=#{install_dir}/embedded/include",
             "zlib",
             "shared",
             "-L#{install_dir}/embedded/lib",
             "-I#{install_dir}/embedded/include",
             "-R#{install_dir}/embedded/lib"].join(" ")
  else
    command(["./config",
             "--prefix=#{install_dir}/embedded",
             "--with-zlib-lib=#{install_dir}/embedded/lib",
             "--with-zlib-include=#{install_dir}/embedded/include",
             "zlib",
             "shared",
             "-L#{install_dir}/embedded/lib",
             "-I#{install_dir}/embedded/include"].join(" "),
            :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"})
  end

  # make and install
  command "make", :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
  command "make install"
end
