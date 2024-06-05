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
default_version "1.34"

# version_list: url=https://ftp.gnu.org/gnu/tar/  filter=*.tar.gz
version("1.35") { source sha256: "14d55e32063ea9526e057fbf35fcabd53378e769787eff7919c3755b02d2b57e" }
version("1.34") { source sha256: "03d908cf5768cfe6b7ad588c921c6ed21acabfb2b79b788d1330453507647aed" }
version("1.33") { source sha256: "7c77c427e8cce274d46a6325d45a55b08e13e2d2d0c9e6c0860a6d2b9589ff0e" }
version("1.32") { source sha256: "b59549594d91d84ee00c99cf2541a3330fed3a42c440503326dab767f2fbb96c" }
version("1.30") { source sha256: "4725cc2c2f5a274b12b39d1f78b3545ec9ebb06a6e48e8845e1995ac8513b088" }
version("1.29") { source sha256: "cae466e6e58c7292355e7080248f244db3a4cf755f33f4fa25ca7f9a7ed09af0" }

license "GPL-3.0"
license_file "COPYING"

source url: "https://ftp.gnu.org/gnu/tar/tar-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/tar-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

relative_path "tar-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  configure_command = [
    "./configure",
    "FORCE_UNSAFE_CONFIGURE=1",
    "--prefix=#{install_dir}/embedded",
  ]

  # First off let's disable selinux support, as it causes issues on some platforms
  # We're not doing it on every platform because this breaks on macOS
  unless osx?
    configure_command << " --without-selinux"
  end

  if s390x?
    # s390x doesn't support posix acls
    configure_command << " --without-posix-acls"
  elsif aix? && version.satisfies?("< 1.32")
    # xlc doesn't allow duplicate entries in case statements
    patch_env = env.dup
    patch_env["PATH"] = "/opt/freeware/bin:#{env["PATH"]}"
    patch source: "aix_extra_case.patch", plevel: 0, env: patch_env
  end

  command configure_command.join(" "), env: env
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
