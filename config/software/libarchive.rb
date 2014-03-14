#
# Copyright:: Copyright (c) 2014 Chef Software, Inc.
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

# A requirement for api.berkshelf.com that is used in berkshelf specs
# https://github.com/berkshelf/api.berkshelf.com

name "libarchive"
default_version "3.1.2"

source :url => "http://www.libarchive.org/downloads/libarchive-#{version}.tar.gz",
  :md5 => 'efad5a503f66329bb9d2f4308b5de98a'

relative_path "libarchive-#{version}"

env =
  case platform
  when "mac_os_x"
    {
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "CFLAGS" => "-I#{install_dir}/embedded/include -L#{install_dir}/embedded/lib"
    }
  else
    {
      "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
    }
  end

# For more info: http://www.linuxfromscratch.org/blfs/view/svn/general/libarchive.html
build do
  command "./configure --prefix=#{install_dir}/embedded", :env => env
  command "make", :env => env
  command "make install", :env => env
end
