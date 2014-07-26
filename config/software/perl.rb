#
# Copyright 2014 Chef Software, Inc.omnibus
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
  env = with_standard_compiler_flags

  command "sh Configure" \
          " -de" \
          " -Dprefix=#{install_dir}/embedded" \
          " -Duseshrplib" \
          " -Dusethreads" \
          " -Dnoextensions='DB_File GDBM_File NDBM_File ODBM_File'", env: env

  command "make -j #{max_build_jobs}", env: env
  command "make install", env: env
end
