#
# Copyright:: Copyright (c) 2012-2014 Chef Software, Inc.
# License:: Apache License, Version 2.0
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

name "libiconv"
default_version "1.14"

dependency "libgcc"
dependency "config_guess"

source url: "https://ftp.gnu.org/pub/gnu/libiconv/libiconv-#{version}.tar.gz",
       sha256: "72b24ded17d687193c3366d0ebe7cde1e6b18f0df8c55438ac95be39e8a30613",
       extract: :seven_zip

relative_path "libiconv-#{version}"

env = case ohai["platform"]
      when "aix"
        {
          "CC" => "xlc -q64",
          "CXX" => "xlC -q64",
          "LDFLAGS" => "-q64 -Wl,-blibpath:/usr/lib:/lib",
          "CFLAGS" => "-O -q64 -I#{install_dir}/embedded/include",
          "CXXFLAGS" => "-O -q64 -I#{install_dir}/embedded/include",
          "LD" => "ld -b64",
          "OBJECT_MODE" => "64",
          "ARFLAGS" => "-X64 cru ",
        }
      else
        {
          "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
          "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
        }
      end

if ohai["platform"] == "solaris2"
  env_more = {
    "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc",
    "LD_OPTIONS" => "-R#{install_dir}/embedded/lib",
  }
  env.merge!(env_more)
end

build do
  license "LGPL-2.1"
  license_file "./COPYING"
  license_file "./COPYING.lib"

  patch source: "libiconv-1.14_srclib_stdio.in.h-remove-gets-declarations.patch"
  update_config_guess(target: "build-aux")
  update_config_guess(target: "libcharset/build-aux")

  configure_options = [
    " --disable-static",
  ]
  configure(*configure_options, env: env)
  command "make -j #{workers}", env: env
  command "make -j #{workers} install-lib libdir=#{install_dir}/embedded/lib includedir=#{install_dir}/embedded/include", env: env
end
