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

source url: "https://www.kernel.org/pub/software/scm/git/git-#{version}.tar.gz"

version("2.7.1") { source md5: "846ac45a1638e9a6ff3a9b790f6c8d99" }
version("2.6.2") { source md5: "da293290da69f45a86a311ad3cd43dc8" }
version("2.2.1") { source md5: "ff41fdb094eed1ec430aed8ee9b9849c" }
version("1.9.5") { source md5: "e9c82e71bec550e856cccd9548902885" }
version("1.9.0") { source md5: "0e00839539fc43cd2c350589744f254a" }

relative_path "git-#{version}"

build do

  env = with_standard_compiler_flags(with_embedded_path).merge(
    "NEEDS_LIBICONV"       => "1",
    "NO_GETTEXT"           => "1",
    "NO_PYTHON"            => "1",
    # Disabling perl - we don't currently need any of the provided
    # functionality: https://github.com/git/git/blob/563e38491eaee6e02643a22c9503d4f774d6c5be/INSTALL#L102-L109
    # Perl on certain platforms (like OSX) brings along libgcc as a dependency,
    # which we'd like to avoid.
    "NO_PERL"              => "1",
    "NO_R_TO_GCC_LINKER"   => "1",
    "NO_TCLTK"             => "1",
    "NO_INSTALL_HARDLINKS" => "1",

    "CURLDIR"    => "#{install_dir}/embedded",
    "EXPATDIR"   => "#{install_dir}/embedded",
    "ICONVDIR"   => "#{install_dir}/embedded",
    "LIBPCREDIR" => "#{install_dir}/embedded",
    "OPENSSLDIR" => "#{install_dir}/embedded",
    "ZLIB_PATH"  => "#{install_dir}/embedded",
  )

  # AIX needs /opt/freeware/bin only for patch
  if aix?
    patch_env = env.dup
    patch_env['PATH'] = "/opt/freeware/bin:#{env['PATH']}"

    # But only needs the below for 1.9.5
    if version == '1.9.5'
      patch source: "aix-strcmp-in-dirc.patch", plevel: 1, env: patch_env
    end

    # this may be needed for 2.6.2 as well, but 2.6.2 won't compile
    # on AIX for other reasons.
    if version <= '2.2.1'
      patch source: "aix-use-freeware-install.patch", plevel: 1, env: patch_env
    end
  end

  configure_command = ["./configure",
                       "--prefix=#{install_dir}/embedded"]

  if freebsd?
    configure_command << "--enable-pthreads=-pthread"
    configure_command << "ac_cv_header_libcharset_h=no"
    configure_command << "--with-curl=#{install_dir}/embedded"
    configure_command << "--with-expat=#{install_dir}/embedded"
  end

  command configure_command.join(" "), env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
