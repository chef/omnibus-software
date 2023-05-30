#
# Copyright:: Copyright (c) 2012-2014 Chef Software, Inc.
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
default_version "1.11"

dependency "libgcc"

source url: "https://ftp.gnu.org/gnu/gdbm/gdbm-#{version}.tar.gz",
       sha256: "8d912f44f05d0b15a4a5d96a76f852e905d051bb88022fcdfd98b43be093e3c3"

relative_path "gdbm-#{version}"

build do
  env = case ohai["platform"]
        when "solaris2"
          {
            "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -R#{install_dir}/embedded/lib",
            "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
            "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
            "LD_OPTIONS" => "-R#{install_dir}/embedded/lib",
          }
        else
          {
            "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
            "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
            "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
          }
        end

  configure_command = ["./configure",
                       "--enable-libgdbm-compat",
                       "--prefix=#{install_dir}/embedded"]

  if ohai["platform"] == "freebsd"
    configure_command << "--with-pic"
  end

  command configure_command.join(" "), env: env
  command "make -j #{workers}", env: env
  command "make install", env: env
end
