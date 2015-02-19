#
# Copyright 2014 Chef Software, Inc.
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

name "perl"
default_version "5.18.1"

source url: "http://www.cpan.org/src/5.0/perl-#{version}.tar.gz",
       md5: "304cb5bd18e48c44edd6053337d3386d"

relative_path "perl-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  if solaris2?
    cc_command = "-Dcc='gcc -static-libgcc -Wl,-M /export/home/shain/dev/solaris_mapfile"
  else
    cc_command = "-Dcc='gcc -static-libgcc'"
  end

  configure_command = ["sh Configure",
                       " -de",
                       " -Dprefix=#{install_dir}/embedded",
                       " -Duseshrplib",
                       " -Dusethreads",
                       " #{cc_command}",
                       " -Dnoextensions='DB_File GDBM_File NDBM_File ODBM_File'"]

  command configure_command.join(" "), env: env
  make "-j #{workers}", env: env
  make "install", env: env
end
