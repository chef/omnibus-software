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
default_version "1.14"

dependency "config-guess"
dependency "patch" if solaris2?
dependency "mingw-runtime" if windows?

source url: "http://ftp.gnu.org/pub/gnu/libiconv/libiconv-#{version}.tar.gz",
       md5: 'e34509b1623cec449dfeb73d7ce9c6c6'

relative_path "libiconv-#{version}"

build do
  # For now, just use the libiconv that comes with TDM gcc on windows.
  unless windows?
    env = with_standard_compiler_flags(with_embedded_path)

    # freebsd 10 needs to be build PIC
    env['CFLAGS'] << " -fPIC" if freebsd?

    copy "#{Omnibus::Config.source_dir}/config-guess/config.guess", "build-aux/config.guess"
    copy "#{Omnibus::Config.source_dir}/config-guess/config.sub", "build-aux/config.sub"
    copy "#{Omnibus::Config.source_dir}/config-guess/config.guess", "libcharset/build-aux/config.guess"
    copy "#{Omnibus::Config.source_dir}/config-guess/config.sub", "libcharset/build-aux/config.sub"

    configure_command = "./configure" \
                        " --prefix=#{install_dir}/embedded"
    if aix?
      patch_env = env.dup
      patch_env['PATH'] = "/opt/freeware/bin:#{env['PATH']}"
      patch source: 'libiconv-1.14_srclib_stdio.in.h-remove-gets-declarations.patch', env: patch_env
    else
      patch source: 'libiconv-1.14_srclib_stdio.in.h-remove-gets-declarations.patch', env: env
    end

    if version == "1.14" && ppc64le?
      patch source: "v1.14.ppc64le-ldemulation.patch", plevel: 1, env: env
    end

    command configure_command, env: env

    make "-j #{workers}", env: env
    make "-j #{workers} install-lib" \
            " libdir=#{install_dir}/embedded/lib" \
            " includedir=#{install_dir}/embedded/include", env: env
  end
end
