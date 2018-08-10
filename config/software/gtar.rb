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

name "gtar"
default_version "1.30"

version("1.30") { source md5: "e0c5ed59e4dd33d765d6c90caadd3c73" }
version("1.29") { source md5: "c57bd3e50e43151442c1995f6236b6e9" }
version("1.28") { source md5: "6ea3dbea1f2b0409b234048e021a9fd7" }

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
  elsif osx?
    # lovingly borrowed from the awesome Homebrew project, thank you!
    # https://github.com/Homebrew/homebrew-core/blob/de3b1aeec9cc8d36f849b0ae959ee4b7f6610c1f/Formula/gnu-tar.rb
    patch source: "gnutar-configure-xattrs.patch", env: env
    env["gl_cv_func_getcwd_abort_bug"] = "no"
  elsif aix?
    if version.satisfies?("<= 1.28")
      # AIX has a gross patch that is required since xlc gets confused by too many #ifndefs
      patch_env = env.dup
      patch_env["PATH"] = "/opt/freeware/bin:#{env['PATH']}"
      patch source: "aix_ifndef.patch", plevel: 0, env: patch_env
    elsif version.satisfies?("> 1.28")
      # xlc doesn't allow duplicate entries in case statements
      patch_env = env.dup
      patch_env["PATH"] = "/opt/freeware/bin:#{env['PATH']}"
      patch source: "aix_extra_case.patch", plevel: 0, env: patch_env
    end
  end

  command configure_command.join(" "), env: env
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
