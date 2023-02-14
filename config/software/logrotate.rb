#
# Copyright 2013-2014 Chef Software, Inc.
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

name "logrotate"
default_version "3.21.0"

license "GPL-2.0"
license_file "COPYING"
skip_transitive_dependency_licensing true

dependency "popt"

source url: "https://github.com/logrotate/logrotate/archive/#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

# versions_list: https://github.com/logrotate/logrotate/tags filter=*.tar.gz

version("3.21.0") { source sha256: "7f58d6ab7e4eab3403528a88d3747a91b03e83e866a8fb966551016e0df527bb" }
version("3.20.1") { source sha256: "f37458dee3b4adab6719767ad4b93ff9ec8948755d1148b76f7f4c2c68d3e457" }
version("3.19.0") { source sha256: "7de1796cb99ce4ed21770b5dae0b4e6f81de0b4df310a58a1617d8061b1e0930" }
version("3.18.1") { source sha256: "18e9c9b85dd185e79f097f4e7982bc5b8c137300756a7878e8fa24731f2f8e21" }
version("3.9.2")  { source sha256: "2de00c65e23fa9d7909cae6594e550b9abe9a7eb1553669ddeaca92d30f97009" }

relative_path "logrotate-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path).merge(
    # Patch allows this to be set manually
    "BASEDIR" => "#{install_dir}/embedded"
  )

  # These EXTRA_* vars allow us to append to the Makefile's hardcoded LDFLAGS
  # and CFLAGS
  env["EXTRA_LDFLAGS"] = env["LDFLAGS"]
  env["EXTRA_CFLAGS"]  = env["CFLAGS"]

  if version == "3.9.2"
    patch source: "logrotate_basedir_override.patch", plevel: 0, env: env
  else
    command   "autoreconf -fiv", env: env
    command   "./configure --prefix=#{install_dir}/embedded", env: env
  end

  make "-j #{workers}", env: env

  # Yes, this is horrible. Due to how the makefile is structured, we need to
  # specify PREFIX, *but not BASEDIR* in order to get this installed into
  # +"#{install_dir}/embedded/sbin"+
  make "install", env: { "PREFIX" => "#{install_dir}/embedded" }
end
