#
# Copyright 2019-2020 Chef Software, Inc.
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

# This software definition installs project called 'patchelf' which can be
# used to change rpath of a precompiled binary.

name "patchelf"

default_version "0.14.5"

license :project_license

skip_transitive_dependency_licensing true

# version_list: url=https://github.com/NixOS/patchelf/releases filter=*.tar.gz

relative_path "patchelf-#{version}"
version("0.14.5") { source sha256: "113ada3f1ace08f0a7224aa8500f1fa6b08320d8f7df05ff58585286ec5faa6f" }

version "0.13.1" do
  source sha256: "08c0237e89be74d61ddf8f6ff218439cdd62af572d568fb38913b53e222831de"
  relative_path "patchelf-0.13.1.20211127.72b6d44"
end

version "0.11" do
  source sha256: "e52378cc2f9379c6e84a04ac100a3589145533a7b0cd26ef23c79dfd8a9038f9"
  relative_path "patchelf-0.11.20200609.d6b2a72"
end

version("0.10") { source sha256: "b2deabce05c34ce98558c0efb965f209de592197b2c88e930298d740ead09019" }

if version.satisfies?(">= 0.12")
  source url: "https://github.com/NixOS/patchelf/releases/download/#{version}/patchelf-#{version}.tar.gz"
else
  source url: "https://nixos.org/releases/patchelf/patchelf-#{version}/patchelf-#{version}.tar.gz"
end

build do
  env = with_standard_compiler_flags(with_embedded_path)
  configure "--prefix #{install_dir}/embedded"
  make env: env
  make "install", env: env
end
