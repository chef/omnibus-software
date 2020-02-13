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

default_version "0.10"

license :project_license

skip_transitive_dependency_licensing true

version("0.10") { source md5: "228ade8c1b4033670bcf7f77c0ea1fb7" }

source url: "https://nixos.org/releases/patchelf/patchelf-#{version}/patchelf-#{version}.tar.gz"

relative_path "patchelf-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  configure "--prefix #{install_dir}/embedded"
  make env: env
  make "install", env: env
end
