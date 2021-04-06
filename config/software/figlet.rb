#
# Copyright 2015 Chef Software, Inc.
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
# expeditor/ignore: deprecated 2021-04

name "figlet"
default_version "2.2.5"

version("2.2.5") { source md5: "eaaeb356007755c9770a842aefd8ed5f" }

source url: "https://github.com/cmatsuoka/figlet/archive/#{version}.tar.gz"

relative_path "figlet-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env["DEFAULTFONTDIR"] = "#{install_dir}/share/figlet/fonts"
  env["prefix"] = "#{install_dir}/embedded"

  if aix?
    # give us /opt/freeware/bin/patch
    env["PATH"] = "/opt/freeware/bin:#{env["PATH"]}"
    env["CC"] = "cc_r -q64"
    env["LD"] = "cc_r -q64"
    patch source: "aix-figlet-cdefs.patch", plevel: 0, env: env
  end

  mkdir "#{install_dir}/share/figlet/fonts"

  make "-j #{workers}", env: env
  make "install -j #{workers}", env: env
end
