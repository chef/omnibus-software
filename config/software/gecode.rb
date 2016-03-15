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

name "gecode"
default_version "3.7.3"

source url: "http://www.gecode.org/download/gecode-#{version}.tar.gz"

version("3.7.3") { source md5: "7a5cb9945e0bb48f222992f2106130ac" }
version("3.7.1") { source md5: "b4191d8cfafa18bd9b78594544be2a04" }

# Major version, have not tried yet
version("4.4.0") { source md5: "a892852927b12ed291b435c72c085834" }

relative_path "gecode-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # On some RHEL-based systems, the default GCC that's installed is 4.1. We
  # need to use 4.4, which is provided by the gcc44 and gcc44-c++ packages.
  # These do not use the gcc binaries so we set the flags to point to the
  # correct version here.
  if File.exist?("/usr/bin/gcc44")
    env["CC"]  = "gcc44"
    env["CXX"] = "g++44"
  end

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --disable-doc-dot" \
          " --disable-doc-search" \
          " --disable-doc-tagfile" \
          " --disable-doc-chm" \
          " --disable-doc-docset" \
          " --disable-qt" \
          " --disable-examples", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
