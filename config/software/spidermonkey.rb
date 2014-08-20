#
# Copyright 2012-2014 Chef Software, Inc.
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

source url: "http://ftp.mozilla.org/pub/mozilla.org/js/js-#{version}-rc1.tar.gz",
       md5: "eaad8815dcc66a717ddb87e9724d964e"

relative_path "js/src"

# == Build Notes ==
# The spidermonkey build instructions are copied from here:
# http://wiki.apache.org/couchdb/Installing_SpiderMonkey
#
# These instructions only seem to work with spidermonkey 1.8.0-rc1 and
# earlier. Since couchdb 1.1.1 is compatible with spidermonkey 1.8.5,
# we should eventually invest some time into getting that version built.
#

build do
  env = with_standard_compiler_flags(with_embedded_path).merge(
    "BUILD_OPT" => "1",
    "JS_DIST"   => "#{install_dir}/embedded",
  )

  env["XCFLAGS"] = env['CFLAGS']

  make "-f Makefile.ref", env: env
  make "-f Makefile.ref export", env: env

  if ohai['kernel']['machine'] =~ /x86_64/
    move "#{install_dir}/embedded/lib64/libjs.a", "#{install_dir}/embedded/lib"
    move "#{install_dir}/embedded/lib64/libjs.so", "#{install_dir}/embedded/lib"
  end

  delete "#{install_dir}/embedded/lib64"
end
