#
# Copyright 2014-2018 Chef Software, Inc.
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
default_version "2.19.2"

license "LGPL-2.1"
license_file "LGPL-2.1"
skip_transitive_dependency_licensing true

dependency "curl"
dependency "zlib"
dependency "openssl"
dependency "pcre"
dependency "libiconv" # FIXME: can we figure out how to remove this?
dependency "expat"

relative_path "git-#{version}"

version "2.19.2" do
  source sha256: "db893ad69c9ac9498b09677c5839787eba2eb3b7ef2bc30bfba7e62e77cf7850"
end

version "2.17.1" do
  source sha256: "ec6452f0c8d5c1f3bcceabd7070b8a8a5eea11d4e2a04955c139b5065fd7d09a"
end

version "2.15.1" do
  source sha256: "85fca8781a83c96ba6db384cc1aa6a5ee1e344746bafac1cbe1f0fe6d1109c84"
end

version "2.14.1" do
  source sha256: "01925349b9683940e53a621ee48dd9d9ac3f9e59c079806b58321c2cf85a4464"
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
  elsif aix?
    env["CC"] = "xlc_r"
    env["INSTALL"] = "/opt/freeware/bin/install"
    # xlc doesn't understand the '-Wl,-rpath' syntax at all so... we don't enable
    # the NO_R_TO_GCC_LINKER flag. This means that it will try to use the
    # old style -R for libraries and as a result, xlc will ignore it. In this case, we
    # we want that to happen because we explicitly set the libpath with the correct
    # command line argument in omnibus itself.
    config_hash["NO_REGEX"] = "NeedsStartEnd"
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
