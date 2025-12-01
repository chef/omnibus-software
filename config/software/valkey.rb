#
# Copyright:: Chef Software, Inc.
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

name "valkey"

license "BSD-3-Clause"
license_file "COPYING"
skip_transitive_dependency_licensing true

dependency "config_guess"
dependency "openssl"
dependency "libuuid"
dependency "curl"

default_version "9.0.0"

if suse?
  source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/valkey/9.0.0-sles12-compat.tar.gz",
                  authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}",
                  sha256: "51915470cded6a3782e411f4e88589f9b2628b2b475f330c6d4fa54a12e3d841"
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/valkey/9.0.0-sles12-compat.tar.gz",
                  authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
else
  source url: "https://github.com/valkey-io/valkey/archive/refs/tags/#{version}.tar.gz"
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
  # version_list: url=https://github.com/valkey-io/valkey/archive/refs/tags/ filter=*.tar.gz
  version("9.0.0") { source sha256: "088f47e167eb640ea31af48c81c5d62ee56321f25a4b05d4e54a0ef34232724b" }
end
relative_path "valkey-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path).merge(
    "PREFIX" => "#{install_dir}/embedded"
  )
  env["CFLAGS"] << " -I#{install_dir}/embedded/include"
  env["LDFLAGS"] << " -L#{install_dir}/embedded/lib"

  if suse? && ohai["platform_version"].to_s.start_with?("12")
    # SLES12: no LTO, C11 for stdatomic shim, and force libc allocator
    patch source: "config-sles.patch", plevel: 0, env: env
    patch source: "no-jemalloc-sles12.patch", plevel: 1, env: env
    env["CFLAGS"] << " -fno-lto -std=c11 -DMALLOC=libc"
    env["CXXFLAGS"] << " -fno-lto"
    env["MALLOC"] = "libc"
  elsif suse?
    # SLES15+: keep existing behavior (jemalloc OK)
    patch source: "config-sles.patch", plevel: 0, env: env
    env["CFLAGS"] << " -fno-lto"
    env["CXXFLAGS"] << " -fno-lto"
  end

  update_config_guess

  # Clean out any previous jemalloc / config state so MALLOC=libc is honored
  command "make -C #{project_dir} distclean", env: env rescue nil
  # command "rm -f #{project_dir}/config.mak #{project_dir}/src/config.h", env: env rescue nil

  make "-j #{workers}", env: env
  make "install", env: env
end