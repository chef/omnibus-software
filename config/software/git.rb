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
default_version "2.14.1"

license "LGPL-2.1"
license_file "LGPL-2.1"
skip_transitive_dependency_licensing true

dependency "curl"
dependency "zlib"
dependency "openssl"
dependency "pcre"
dependency "libiconv"
dependency "expat"

relative_path "git-#{version}"

version "2.15.1" do
  source sha256: "85fca8781a83c96ba6db384cc1aa6a5ee1e344746bafac1cbe1f0fe6d1109c84"
end

version "2.14.1" do
  source sha256: "01925349b9683940e53a621ee48dd9d9ac3f9e59c079806b58321c2cf85a4464"
end

version "2.10.2" do
  source md5: "45e8b30a9e7c1b734128cc0fc6663619"
end

version "2.8.2" do
  source md5: "3022d8ebf64b35b9704d5adf54b256f9"
end

version "2.7.4" do
  source md5: "c64012d491e24c7d65cd389f75383d91"
end

version "2.7.3" do
  source md5: "cf6ed3510f0d7784da5e9f4e64c6a43e"
end

version "2.7.1" do
  source md5: "846ac45a1638e9a6ff3a9b790f6c8d99"
end

version "2.6.2" do
  source md5: "da293290da69f45a86a311ad3cd43dc8"
end

version "2.2.1" do
  source md5: "ff41fdb094eed1ec430aed8ee9b9849c"
end

version "1.9.5" do
  source md5: "e9c82e71bec550e856cccd9548902885"
end

version "1.9.0" do
  source md5: "0e00839539fc43cd2c350589744f254a"
end

source url: "https://www.kernel.org/pub/software/scm/git/git-#{version}.tar.gz"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # We do a distclean so we ensure that the autoconf files are not trying to be
  # clever.
  make "distclean"

  # AIX needs /opt/freeware/bin only for patch
  if aix?
    patch_env = env.dup
    patch_env["PATH"] = "/opt/freeware/bin:#{env['PATH']}"

    # But only needs the below for 1.9.5
    if version == "1.9.5"
      patch source: "aix-strcmp-in-dirc.patch", plevel: 1, env: patch_env
    end

    # In 2.13.1 they introduced some sha code that wasn't super good at
    # endianness. https://github.com/git/git/commit/6b851e536b05e0c8c61f77b9e4c3e7cedea39ff8
    if version.satisfies?(">2.10.2")
      patch source: "aix-endian-fix.patch", plevel: 0, env: patch_env
    end
  end

  config_hash = {
    # Universal options
    NO_GETTEXT: "YesPlease",
    NEEDS_LIBICONV: "YesPlease",
    NO_INSTALL_HARDLINKS: "YesPlease",
    NO_PERL: "YesPlease",
    NO_PYTHON: "YesPlease",
    NO_TCLTK: "YesPlease",
  }

  if freebsd?
    config_hash["CHARSET_LIB"] = "-lcharset"
    config_hash["FREAD_READS_DIRECTORIES"] = "UnfortunatelyYes"
    config_hash["HAVE_CLOCK_GETTIME"] = "YesPlease"
    config_hash["HAVE_CLOCK_MONOTONIC"] = "YesPlease"
    config_hash["HAVE_GETDELIM"] = "YesPlease"
    config_hash["HAVE_PATHS_H"] = "YesPlease"
    config_hash["HAVE_STRINGS_H"] = "YesPlease"
    config_hash["PTHREAD_LIBS"] = "-pthread"
    config_hash["USE_ST_TIMESPEC"] = "YesPlease"
    config_hash["HAVE_BSD_SYSCTL"] = "YesPlease"
    config_hash["NO_R_TO_GCC_LINKER"] = "YesPlease"
  elsif solaris_10?
    env["CC"] = "gcc"
    env["SHELL_PATH"] = "#{install_dir}/embedded/bin/bash"
    config_hash["NEEDS_SOCKET"] = "YesPlease"
    config_hash["NO_R_TO_GCC_LINKER"] = "YesPlease"
  elsif aix?
    env["CC"] = "xlc_r"
    env["INSTALL"] = "/opt/freeware/bin/install"
    # xlc doesn't understand the '-Wl,-rpath' syntax at all so... we don't enable
    # the NO_R_TO_GCC_LINKER flag. This means that it will try to use the
    # old style -R for libraries and as a result, xlc will ignore it. In this case, we
    # we want that to happen because we explicitly set the libpath with the correct
    # command line argument in omnibus itself.
    if version.satisfies?(">=2.10.2")
      config_hash["NO_REGEX"] = "NeedsStartEnd"
    end
  else
    # Linux things!
    config_hash["HAVE_PATHS_H"] = "YesPlease"
    config_hash["NO_R_TO_GCC_LINKER"] = "YesPlease"
  end

  erb source: "config.mak.erb",
      dest: "#{project_dir}/config.mak",
      mode: 0755,
      vars: {
               cc: env["CC"],
               ld: env["LD"],
               cflags: env["CFLAGS"],
               cppflags: env["CPPFLAGS"],
               install: env["INSTALL"],
               install_dir: install_dir,
               ldflags: env["LDFLAGS"],
               shell_path: env["SHELL_PATH"],
               config_hash: config_hash,
             }

  # NOTE - If you run ./configure the environment variables set above will not be
  # used and only the command line args will be used. The issue with this is you
  # cannot specify everything on the command line that you can with the env vars.
  make "prefix=#{install_dir}/embedded -j #{workers}", env: env
  make "prefix=#{install_dir}/embedded install", env: env
end
