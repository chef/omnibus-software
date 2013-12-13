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

name "gdbm"
version "1.9.1"

dependency "libgcc" if (platform != "aix")

source :url => "http://ftp.gnu.org/gnu/gdbm/gdbm-1.9.1.tar.gz",
       :md5 => "59f6e4c4193cb875964ffbe8aa384b58"

relative_path "gdbm-1.9.1"
env = case platform
      when "aix"
        {
	"CC" => "xlc -q64",
	"CXX" => "xlC -q64",
	"LD" => "ld -b64",
	"CFLAGS" => "-q64 -I#{install_dir}/embedded/include -O",
	"OBJECT_MODE" => "64",
	"ARFLAGS" => "-X64 cru",
	"LDFLAGS" => "-q64 -L#{install_dir}/embedded/lib",
	}
end
build do
  configure_command = ["./configure",
                       "--prefix=#{install_dir}/embedded"]

  if platform == "freebsd"
    configure_command << "--with-pic"
  end


  command configure_command.join(" ")
  if platform == "aix"
    command configure_command.join(" "), :env => env
    command "make -j #{max_build_jobs}"
    command "make install"
  else
  command "make -j #{max_build_jobs}"
  command "make install"
  end
end
