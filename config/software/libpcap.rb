#
# Copyright 2014-2019 Pinterest
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

name "libpcap"
default_version "2.25"

license "GPL-v2"
license_file "LICENSE"
skip_transitive_dependency_licensing true
whitelist_file "#{install_dir}/embedded/sbin/getpcaps"
whitelist_file "#{install_dir}/embedded/sbin/capsh"
whitelist_file "#{install_dir}/embedded/sbin/getcap"
whitelist_file "#{install_dir}/embedded/sbin/setcap"

version("2.25") { source sha256: "693c8ac51e983ee678205571ef272439d83afe62dd8e424ea14ad9790bc35162" }

source url: "http://archive.ubuntu.com/ubuntu/pool/main/libc/libcap2/libcap2_#{version}.orig.tar.xz"

relative_path "libcap-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env["prefix"] = "#{install_dir}/embedded"
  env["LD_LIBRARY_PATH"] = "#{install_dir}/embedded/lib64"
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
