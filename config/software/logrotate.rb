#
# Copyright:: Copyright (c) 2013-2014 Chef Software, Inc.
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

name "logrotate"
default_version "3.8.5"

dependency "popt"

source :url => "https://fedorahosted.org/releases/l/o/logrotate/logrotate-#{version}.tar.gz",
       :md5 => "d3c13e2a963a55c584cfaa83e96b173d"

relative_path "logrotate-#{version}"

env = {
  # Patch allows this to be set manually
  "BASEDIR" => "#{install_path}/embedded",

  # These EXTRA_* vars allow us to append to the Makefile's hardcoded LDFLAGS
  # and CFLAGS
  "EXTRA_LDFLAGS" => "-L#{install_path}/embedded/lib -I#{install_path}/embedded/include",
  "EXTRA_CFLAGS" => "-L#{install_path}/embedded/lib -I#{install_path}/embedded/include",

  # Needed to find libpopt
  "LD_RUN_PATH" => "#{install_path}/embedded/lib"
}

build do
  patch :source => "logrotate_basedir_override.patch", :plevel => 0
  command "make -j #{max_build_jobs}", :env => env

  # Yes, this is horrible.  Due to how the makefile is structured, we
  # need to specify PREFIX, *but not BASEDIR* in order to get this
  # installed into #{install_path}/embedded/sbin
  #
  # :(
  command "make install", :env => {"PREFIX" => "#{install_path}/embedded"}
end
