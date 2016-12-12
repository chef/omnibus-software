#
# Copyright 2016 Chef Software, Inc.
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

# NOTE: you will most likely want to enable openssl fips in your project file like:
#
# override :fips, enabled: true
#
# Also, due to linking difficulty, you can't have openssl fips enabled in a project
# you also want openssl non-fips, so making a separate project to wrap stunnel is
# likely needed.

# NOTE: FIPS defaults to on, since that makes the most sense for stunnel,
# compared to other software definitions where it defaults to off.
fips_enabled = (project.overrides[:fips] && project.overrides[:fips][:enabled]) || true

name "stunnel"
default_version "5.38"

license "GPL-2.0"
license_file "COPYING"
skip_transitive_dependency_licensing true

dependency "openssl"

source url:
"https://www.stunnel.org/downloads/stunnel-#{version}.tar.gz"
relative_path "stunnel-#{version}"

version "5.38" do
  source sha256: "09ada29ba1683ab1fd1f31d7bed8305127a0876537e836a40cb83851da034fd5"
end

build do
  env = with_standard_compiler_flags(with_embedded_path)
  configure_string = "./configure --with-ssl=#{install_dir}/embedded --prefix=#{install_dir}/embedded"
  if fips_enabled
    configure_string += " --enable-fips"
  end
  command configure_string, env: env
  make env: env
  make "install", env: env
end
