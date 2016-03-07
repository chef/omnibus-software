#
# Copyright 2014 Chef Software, Inc.
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

name "perl"

if windows?
  default_version "5.8.8"
  dependency "mingw-get"
else
  default_version "5.18.1"

  source url: "http://www.cpan.org/src/5.0/perl-#{version}.tar.gz"

  version('5.22.1') { source md5: '19295bbb775a3c36123161b9bf4892f1' }
  version('5.18.1') { source md5: '304cb5bd18e48c44edd6053337d3386d' }

  relative_path "perl-#{version}"
end

build do
  env = with_standard_compiler_flags(with_embedded_path)

  if windows?
    command "mingw-get.exe -v install msys-perl-bin=#{version}-*",
            env: env, cwd: "#{install_dir}/embedded"
  else
    solaris_mapfile_path = File.expand_path(Omnibus::Config.solaris_linker_mapfile, Omnibus::Config.project_root)
    if solaris2? && File.exist?(solaris_mapfile_path)
      cc_command = "-Dcc='gcc -static-libgcc -Wl,-M #{solaris_mapfile_path}"
    elsif aix?
      cc_command = "-Dcc='/opt/IBM/xlc/13.1.0/bin/cc_r -q64'"
    elsif freebsd? && ohai['os_version'].to_i >= 1000024
      cc_command = "-Dcc='clang'"
    else
      cc_command = "-Dcc='gcc -static-libgcc'"
    end

    configure_command = ["sh Configure",
                        " -de",
                        " -Dprefix=#{install_dir}/embedded",
                        " -Duseshrplib",
                        " -Dusethreads",
                        " #{cc_command}",
                        " -Dnoextensions='DB_File GDBM_File NDBM_File ODBM_File'"]

    if aix?
      configure_command << "-Dmake=gmake"
      configure_command << "-Duse64bitall"
    end

    # On Cisco IOS-XR, we don't want libssp as a dependency
    if ios_xr?
      configure_command << "-Accflags=-fno-stack-protector"
    end

    command configure_command.join(" "), env: env
    make "-j #{workers}", env: env
    # using the install.perl target lets
    # us skip install the manpages
    make "install.perl", env: env
  end
end
