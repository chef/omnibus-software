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
  source url: "#{ENV['ARTIFACTORY_REPO_URL']}/valkey/9.0.0-sles12-compat.tar.gz",
                  authorization: "X-JFrog-Art-Api:#{ENV['ARTIFACTORY_TOKEN']}",
                  sha256: "f4d059b8348f067d5a490ee5e01a5b9ecb653c02560181366d1e2bc86589faf9"
  internal_source url: "#{ENV['ARTIFACTORY_REPO_URL']}/valkey/9.0.0-sles12-compat.tar.gz",
                  authorization: "X-JFrog-Art-Api:#{ENV['ARTIFACTORY_TOKEN']}"
else
  source url: "https://github.com/valkey-io/valkey/archive/refs/tags/#{version}.tar.gz"
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end
relative_path "valkey-#{version}"

# version_list: url=https://github.com/valkey-io/valkey/archive/refs/tags/ filter=*.tar.gz
version("9.0.0") { source sha256: "088f47e167eb640ea31af48c81c5d62ee56321f25a4b05d4e54a0ef34232724b" }

build do
  env = with_standard_compiler_flags(with_embedded_path).merge(
    "PREFIX" => "#{install_dir}/embedded"
  )
  env["CFLAGS"] << " -I#{install_dir}/embedded/include"
  env["LDFLAGS"] << " -L#{install_dir}/embedded/lib"
  # if version.satisfies?(">=6.3.4")
  #   patch source: "remove-libatomic-dep", env: env
  # end
  # if suse?
  #   env["CFLAGS"] << " -fno-lto"
  #   env["CXXFLAGS"] << " -fno-lto"
  # end
  if suse?
    patch source: "config-sles.patch", plevel: 0, env: env
    env["CFLAGS"] << " -fno-lto"
    env["CXXFLAGS"] << " -fno-lto"
  end
  update_config_guess
  make "-j #{workers}", env: env
  make "install", env: env
end
