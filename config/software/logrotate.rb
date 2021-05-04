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

# versions_list: https://github.com/logrotate/logrotate/releases/ filter=*.tar.gz
version("3.18.0") { source sha256: "ceddb34dd2f33c324413e6eacb548cc5b873276709154895a44cf6259d2d37b6" }
version("3.17.0") { source sha256: "5db8cf4786e0abeeec64f852d605ef702bfcf18f4d7938dce7d7a00ad4de787c" }
version("3.16.0") { source sha256: "e1bae2c72115cf16007bb98ea38752d1120010cfb70addd9867d952c7529de3b" }
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
