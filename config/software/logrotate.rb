#
# Copyright 2013-2014 Chef Software, Inc.
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
default_version "3.18.1"

license "GPL-2.0"
license_file "COPYING"
skip_transitive_dependency_licensing true

dependency "popt"

source url: "https://github.com/logrotate/logrotate/archive/#{version}.tar.gz"

# versions_list: https://github.com/logrotate/logrotate/tags filter=*.tar.gz

version("3.18.1") { source sha256: "5db8d0d9600a260e5b6dc4498aa7c1a6910a51b611611005f652a4f606d0a23b" }
version("3.9.2")  { source sha256: "2de00c65e23fa9d7909cae6594e550b9abe9a7eb1553669ddeaca92d30f97009" }

relative_path "logrotate-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path).merge(
    # Patch allows this to be set manually
    "BASEDIR" => "#{install_dir}/embedded"
  )

  # These EXTRA_* vars allow us to append to the Makefile's hardcoded LDFLAGS
  # and CFLAGS
  env["EXTRA_LDFLAGS"] = env["LDFLAGS"]
  env["EXTRA_CFLAGS"]  = env["CFLAGS"]

  patch source: "logrotate_basedir_override.patch", plevel: 0, env: env

  make "-j #{workers}", env: env

  # Yes, this is horrible. Due to how the makefile is structured, we need to
  # specify PREFIX, *but not BASEDIR* in order to get this installed into
  # +"#{install_dir}/embedded/sbin"+
  make "install", env: { "PREFIX" => "#{install_dir}/embedded" }
end
