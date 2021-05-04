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
default_version "3.18.0"

license "GPL-2.0"
license_file "COPYING"
skip_transitive_dependency_licensing true

dependency "popt"

source url: "https://github.com/logrotate/logrotate/archive/#{version}.tar.gz"

# versions_list: https://github.com/logrotate/logrotate/tags filter=*.tar.gz
version("3.18.0") { source sha256: "66232111a2b02cce3c2436c141b7a2af78fa758aac326ab2b79f9a5b0d749142" }
version("3.17.0") { source sha256: "c25ea219018b024988b791e91e9f6070c34d2056efa6ffed878067866c0ed765" }
version("3.16.0") { source sha256: "bc6acfd09925045d48b5ff553c24c567cfd5f59d513c4ac34bfb51fa6b79dc8a" }
version("3.9.2") { source sha256: "2de00c65e23fa9d7909cae6594e550b9abe9a7eb1553669ddeaca92d30f97009" }
version("3.8.9") { source sha256: "be4df08cd09271b065f02c79a165cad247acc0506cd7f6cb80f5b5a4e0f8d517" }

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
