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

name "git"
default_version "1.9.5"

dependency "curl"
dependency "zlib"
dependency "openssl"
dependency "pcre"
dependency "libiconv"
dependency "expat"
dependency "perl"

relative_path "git-#{version}"

version "1.9.0" do
  source md5: "0e00839539fc43cd2c350589744f254a"
end

version "1.9.5" do
  source md5: "e9c82e71bec550e856cccd9548902885"
end

version "2.2.1" do
  source md5: "ff41fdb094eed1ec430aed8ee9b9849c"
end

version "2.6.2" do
  source md5: "da293290da69f45a86a311ad3cd43dc8"
end

source url: "https://www.kernel.org/pub/software/scm/git/git-#{version}.tar.gz"

build do

  env = with_standard_compiler_flags(with_embedded_path).merge(
    "NEEDS_LIBICONV"     => "1",
    "NO_GETTEXT"         => "1",
    "NO_PYTHON"          => "1",
    "NO_R_TO_GCC_LINKER" => "1",
    "NO_TCLTK"           => "1",

    "CURLDIR"    => "#{install_dir}/embedded",
    "EXPATDIR"   => "#{install_dir}/embedded",
    "ICONVDIR"   => "#{install_dir}/embedded",
    "LIBPCREDIR" => "#{install_dir}/embedded",
    "OPENSSLDIR" => "#{install_dir}/embedded",
    "PERL_PATH"  => "#{install_dir}/embedded/bin/perl",
    "ZLIB_PATH"  => "#{install_dir}/embedded",
  )

  # AIX needs /opt/freeware/bin only for patch
  patch_env = env.dup
  patch_env['PATH'] = "/opt/freeware/bin:#{env['PATH']}" if aix?

  patch source: "aix-use-freeware-install.patch", plevel: 1, env: patch_env if aix?
  patch source: "aix-strcmp-in-dirc.patch", plevel: 1, env: patch_env if aix?

  configure_command = ["./configure",
                       "--prefix=#{install_dir}/embedded"]

  if freebsd?
    configure_command << "--enable-pthreads=-pthread"
    configure_command << "ac_cv_header_libcharset_h=no"
    configure_command << "--with-curl=#{install_dir}/embedded"
    configure_command << "--with-expat=#{install_dir}/embedded"
    configure_command << "--with-perl=#{install_dir}/embedded/bin/perl"
  elsif aix?
    # without this, git produces some nroff files with "::" in the filename
    # causing the install process to fail with "sysck: 3001-019"
    configure_command << "--docdir='/dev/null'"
  end

  command configure_command.join(" "), env: env
  make "-j #{workers}", env: env
  make "install", env: env
end
