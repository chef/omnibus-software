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

name "bash"
default_version "5.2.15"

dependency "libiconv"
dependency "ncurses"
skip_transitive_dependency_licensing true

# version_list: url=https://ftp.gnu.org/gnu/bash/ filter=*.tar.gz

version("5.0")    { source sha256: "b4a80f2ac66170b2913efbfb9f2594f1f76c7b1afd11f799e22035d63077fb4d" }
version("5.1")    { source sha256: "cc012bc860406dcf42f64431bcd3d2fa7560c02915a601aba9cd597a39329baa" }
version("5.1.8")  { source sha256: "0cfb5c9bb1a29f800a97bd242d19511c997a1013815b805e0fdd32214113d6be" }
version("5.1.16") { source sha256: "5bac17218d3911834520dad13cd1f85ab944e1c09ae1aba55906be1f8192f558" }
version("5.2")    { source sha256: "a139c166df7ff4471c5e0733051642ee5556c1cc8a4a78f145583c5c81ab32fb" }
version("5.2.9")  { source sha256: "68d978264253bc933d692f1de195e2e5b463a3984dfb4e5504b076865f16b6dd" }
version("5.2.15") { source sha256: "13720965b5f4fc3a0d4b61dd37e7565c741da9a5be24edc2ae00182fc1b3588c" }

license "GPL-3.0"
license_file "COPYING"

source url: "https://ftp.gnu.org/gnu/bash/bash-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

# bash builds bash as libraries into a special directory. We need to include
# that directory in lib_dirs so omnibus can sign them during macOS deep signing.
lib_dirs lib_dirs.concat ["#{install_dir}/embedded/lib/bash"]

relative_path "bash-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # FreeBSD can build bash with this patch but it doesn't work properly
  # Things like command substitution will throw syntax errors even though the syntax is correct
  if version.satisfies?("< 5.2")
    unless freebsd?
      # Fix bash race condition
      # https://lists.gnu.org/archive/html/bug-bash/2020-12/msg00051.html
      patch source: "race-condition.patch", plevel: 1, env: env
    end
  else
    patch source: "updated_race-condition.patch", plevel: 0, env: env
  end
  configure_command = ["./configure",
                       "--prefix=#{install_dir}/embedded"]

  if freebsd?
    # On freebsd, you have to force static linking, otherwise the executable
    # will link against the system ncurses instead of ours.
    configure_command << "--enable-static-link"

    # FreeBSD 12 system files come with mktime but for some reason running "configure"
    # doesn't detect this which results in a build failure. Setting this environment variable
    # corrects that.
    env["ac_cv_func_working_mktime"] = "yes"
  end

  command configure_command.join(" "), env: env
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env

  # We do not install bashbug in macos as it fails Notarization
  delete "#{install_dir}/embedded/bin/bashbug"
end
