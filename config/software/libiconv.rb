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

# CAUTION - although its not used, external libraries such as nokogiri may pick up an optional dep on
# libiconv such that removal of libiconv will break those libraries on upgrade.  With an better story around
# external gem handling when chef-client is upgraded libconv could be dropped.
name "libiconv"
default_version "1.15"

license "LGPL-2.1"
license_file "COPYING.LIB"
skip_transitive_dependency_licensing true

dependency "config_guess"

source url: "https://ftp.gnu.org/pub/gnu/libiconv/libiconv-#{version}.tar.gz",
       sha256: "ccf536620a45458d26ba83887a983b96827001e92a13847b45e4925cc8913178"

relative_path "libiconv-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # freebsd 10 needs to be build PIC
  env["CFLAGS"] << " -fPIC" if freebsd?

  update_config_guess(target: "build-aux")
  update_config_guess(target: "libcharset/build-aux")

  configure(env: env)

  pmake = "-j #{workers}"
  make "#{pmake}", env: env
  make "#{pmake} install-lib" \
          " libdir=#{install_dir}/embedded/lib" \
          " includedir=#{install_dir}/embedded/include", env: env
end
