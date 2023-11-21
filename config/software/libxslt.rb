#
# Copyright 2012-2014 Chef Software, Inc.
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

name "libxslt"
default_version "1.1.39"

license "MIT"
license_file "COPYING"
skip_transitive_dependency_licensing true

dependency "libxml2"
dependency "liblzma"
dependency "config_guess"

# versions_list: url=https://download.gnome.org/sources/libxslt/1.1/ filter=*.tar.xz
version("1.1.39") { source sha256: "2a20ad621148339b0759c4d4e96719362dee64c9a096dbba625ba053846349f0" }
version("1.1.37") { source sha256: "3a4b27dc8027ccd6146725950336f1ec520928f320f144eb5fa7990ae6123ab4" }
version("1.1.36") { source sha256: "12848f0a4408f65b530d3962cd9ff670b6ae796191cfeff37522b5772de8dc8e" }
version("1.1.35") { source sha256: "8247f33e9a872c6ac859aa45018bc4c4d00b97e2feac9eebc10c93ce1f34dd79" }
version("1.1.34") { source sha256: "28c47db33ab4daefa6232f31ccb3c65260c825151ec86ec461355247f3f56824" }
version("1.1.30") { source sha256: "db1e4e26eaec47d00f885bad19a8749eb1008909b817d650101365f068ee3b24" }

source url: "https://download.gnome.org/sources/libxslt/1.1/libxslt-#{version}.tar.xz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.xz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

relative_path "libxslt-#{version}"

build do
  update_config_guess

  env = with_standard_compiler_flags(with_embedded_path)

  if version.satisfies?("< 1.1.39")
    patch source: "libxslt-solaris-configure.patch", env: env if solaris2? || omnios? || smartos?
  else
    patch source: "update-libxslt-solaris-configure.patch", env: env if solaris2? || omnios? || smartos?
  end

  if windows?
    patch source: "libxslt-windows-relocate.patch", env: env
  end

  # the libxslt configure script iterates directories specified in
  # --with-libxml-prefix looking for the libxml2 config script. That
  # iteration treats colons as a delimiter so we are using a cygwin
  # style path to accomodate
  configure_commands = [
    "--with-libxml-prefix=#{install_dir.sub("C:", "/C")}/embedded",
    "--without-python",
    "--without-crypto",
    "--without-profiler",
    "--without-debugger",
  ]

  configure(*configure_commands, env: env)

  make "-j #{workers}", env: env
  make "install", env: env
end
