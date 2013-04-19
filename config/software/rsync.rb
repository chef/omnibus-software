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

name "rsync"
version "3.0.9"

dependency "popt"

source :url => "http://rsync.samba.org/ftp/rsync/src/rsync-3.0.9.tar.gz",
       :md5 => "5ee72266fe2c1822333c407e1761b92b"

relative_path "rsync-3.0.9"

env =
  case platform
  when "solaris2"
    if Omnibus.config.solaris_compiler == "studio"
      {
        "LDFLAGS" => "-R #{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
        "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc",
        "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
      }
    elsif Omnibus.config.solaris_compiler == "gcc"
      {
        "LDFLAGS" => "-R #{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc",
        "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc",
        "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
      }
  else
    raise "Sorry, #{Omnibus.config.solaris_compiler} is not a valid compiler selection."
  end

  else
    {
      "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc",
      "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
    }
  end

build do
  command "./configure --prefix=#{install_dir}/embedded --disable-iconv", :env => env
  command "make -j #{max_build_jobs}", :env => env
  command "make install"
end
