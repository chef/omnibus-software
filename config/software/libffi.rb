#
# Copyright 2012-2019, Chef Software Inc.
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

name "libffi"

default_version "3.2.1"

license "MIT"
license_file "LICENSE"
skip_transitive_dependency_licensing true

version("3.0.13") { source md5: "45f3b6dbc9ee7c7dfbbbc5feba571529" }
version("3.2.1")  { source md5: "83b89587607e3eb65c70d361f13bab43" }

source url: "https://www.mirrorservice.org/sites/sourceware.org/pub/libffi/libffi-#{version}.tar.gz"

relative_path "libffi-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  env["INSTALL"] = "/opt/freeware/bin/install" if aix?

  configure_command = []

  # AIX's old version of patch doesn't like the patch here
  unless aix?
    # Patch to disable multi-os-directory via configure flag (don't use /lib64)
    # Works on all platforms, and is compatible on 32bit platforms as well
    if version == "3.2.1"
      patch source: "libffi-3.2.1-disable-multi-os-directory.patch", plevel: 1, env: env
      configure_command << "--disable-multi-os-directory"
    end
  end

  configure(*configure_command, env: env)

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env

  # libffi's default install location of header files is awful...
  copy "#{install_dir}/embedded/lib/libffi-#{version}/include/*", "#{install_dir}/embedded/include"

end
