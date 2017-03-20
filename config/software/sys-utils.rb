#
# Copyright 2017 Chef Software, Inc.
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

name "sys-utils"
default_version "2.29.2"

version "2.29.2" do
  source sha256: "accea4d678209f97f634f40a93b7e9fcad5915d1f4749f6c47bee6bf110fe8e3"
end

source url: "https://www.kernel.org/pub/linux/utils/util-linux/v#{version[/\d+\.\d+/]}/util-linux-#{version}.tar.xz"

license "GPL-2.0"
license_file "COPYING"
skip_transitive_dependency_licensing true

relative_path "util-linux-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  flags = []
  flags << "--disable-dependency-tracking"
  flags << "--disable-all-programs"
  flags << "--enable-unshare"
  flags << "--enable-nsenter"
  flags << "--enable-switch_root"
  flags << "--enable-pivot_root"

  command "./configure" \
          " --prefix=#{install_dir}/embedded #{flags.join(" ")}", env: env

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
