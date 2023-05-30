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

name "spidermonkey"
default_version "1.8.0"

source url: "https://ftp.mozilla.org/pub/mozilla.org/js/js-1.8.0-rc1.tar.gz",
       sha256: "374398699ac3fd802d98d642486cf6b0edc082a119c9c9c499945a0bc73e3413"

relative_path "js"

env = { "LD_RUN_PATH" => "#{install_dir}/embedded/lib" }
working_dir = "#{project_dir}/src"

# == Build Notes ==
# The spidermonkey build instructions are copied from here:
# http://wiki.apache.org/couchdb/Installing_SpiderMonkey
#
# These instructions only seem to work with spidermonkey 1.8.0-rc1 and
# earlier. Since couchdb 1.1.1 is compatible with spidermonkey 1.8.5,
# we should eventually invest some time into getting that version built.
#

build do
  command(["make -j #{workers}",
           "BUILD_OPT=1",
           "XCFLAGS=-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
           "-f",
           "Makefile.ref"].join(" "),
    env: env,
    cwd: working_dir)
  command(["make -j #{workers}",
           "BUILD_OPT=1",
           "JS_DIST=#{install_dir}/embedded",
           "-f",
           "Makefile.ref",
           "export"].join(" "),
    env: env,
    cwd: working_dir)

  if ohai["kernel"]["machine"] =~ /x86_64/
    move "#{install_dir}/embedded/lib64/libjs.a", "#{install_dir}/embedded/lib"
    move "#{install_dir}/embedded/lib64/libjs.so", "#{install_dir}/embedded/lib"
  end
  delete "#{install_dir}/embedded/lib64"
end
