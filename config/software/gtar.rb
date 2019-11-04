#
# Copyright 2016-2019 Chef Software, Inc.
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

name "gtar"
default_version "1.30"

version("1.32") { source sha256: "b59549594d91d84ee00c99cf2541a3330fed3a42c440503326dab767f2fbb96c" }
version("1.30") { source sha256: "4725cc2c2f5a274b12b39d1f78b3545ec9ebb06a6e48e8845e1995ac8513b088" }
version("1.29") { source sha256: "cae466e6e58c7292355e7080248f244db3a4cf755f33f4fa25ca7f9a7ed09af0" }

license "GPL-3.0"
license_file "COPYING"

source url: "http://ftp.gnu.org/gnu/tar/tar-#{version}.tar.gz"

relative_path "tar-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  configure_command = [
    "./configure",
    "--prefix=#{install_dir}/embedded",
  ]

  # First off let's disable selinux support, as it causes issues on some platforms
  # We're not doing it on every platform because this breaks on OSX
  unless osx?
    configure_command << " --without-selinux"
  end

  if nexus? || ios_xr? || s390x?
    # ios_xr and nexus don't support posix acls
    configure_command << " --without-posix-acls"
  elsif aix?
    if version.satisfies?("> 1.28") && version.satisfies?("< 1.32")
      # xlc doesn't allow duplicate entries in case statements
      patch_env = env.dup
      patch_env["PATH"] = "/opt/freeware/bin:#{env["PATH"]}"
      patch source: "aix_extra_case.patch", plevel: 0, env: patch_env
    end
  end

  command configure_command.join(" "), env: env
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
