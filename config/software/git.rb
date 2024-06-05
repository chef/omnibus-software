#
# Copyright:: Chef Software, Inc.
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
default_version "2.39.0"

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

# version_list: url=https://www.kernel.org/pub/software/scm/git/ filter=*.tar.gz

version("2.39.3") { source sha256: "2f9aa93c548941cc5aff641cedc24add15b912ad8c9b36ff5a41b1a9dcad783e" }
version("2.39.0") { source sha256: "d929fe67cef7ac3ca709d2b56a9920f17112d5a524bf8112af37ec045a7a5109" }
version("2.37.3") { source sha256: "181f65587155ea48c682f63135678ec53055adf1532428752912d356e46b64a8" }
version("2.37.2") { source sha256: "4c428908e3a2dca4174df6ef49acc995a4fdb1b45205a2c79794487a33bc06e5" }
version("2.37.1") { source sha256: "7dded96a52e7996ce90dd74a187aec175737f680dc063f3f33c8932cf5c8d809" }
version("2.37.0") { source sha256: "fc3ffe6c65c1f7c681a1ce6bb91703866e432c762731d4b57c566d696f6d62c3" }
version("2.36.1") { source sha256: "37d936fd17c81aa9ddd3dba4e56e88a45fa534ad0ba946454e8ce818760c6a2c" }
version("2.36.0") { source sha256: "9785f8c99daea037b8443d2f7397ac6aafbf8d5ff21fbfe2e5c0d443d126e211" }
version("2.35.3") { source sha256: "cad708072d5c0b390c71651f5edb44143f00b357766973470bf9adebc0944c03" }

# we need to keep 2.24.1 until we can remove the version pin in omnibus-toolchain Solaris builds
version("2.24.1") { source sha256: "ad5334956301c86841eb1e5b1bb20884a6bad89a10a6762c958220c7cf64da02" }

source url: "https://www.kernel.org/pub/software/scm/git/git-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

# git builds git-core as binaries into a special directory. We need to include
# that directory in bin_dirs so omnibus can sign them during macOS deep signing.
bin_dirs bin_dirs.concat ["#{install_dir}/embedded/libexec/git-core"]

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # We do a distclean so we ensure that the autoconf files are not trying to be
  # clever.
  make "distclean"

  # In 2.13.1 they introduced some sha code that wasn't super good at endianness
  if aix?
    # AIX needs /opt/freeware/bin only for patch
    patch_env = env.dup
    patch_env["PATH"] = "/opt/freeware/bin:#{env["PATH"]}"

    patch source: "aix-endian-fix.patch", plevel: 0, env: patch_env
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
    env["CFLAGS"] = "-q64 -qmaxmem=-1 -I#{install_dir}/embedded/include -D_LARGE_FILES -O2"
    env["CPPFLAGS"] = "-q64 -qmaxmem=-1 -I#{install_dir}/embedded/include -D_LARGE_FILES -O2"
    env["LDFLAGS"] = "-q64 -L#{install_dir}/embedded/lib -lcurl -lssl -lcrypto -lz -Wl,-blibpath:#{install_dir}/embedded/lib:/usr/lib:/lib"
    # xlc doesn't understand the '-Wl,-rpath' syntax at all so... we don't enable
    # the NO_R_TO_GCC_LINKER flag. This means that it will try to use the
    # old style -R for libraries and as a result, xlc will ignore it. In this case, we
    # we want that to happen because we explicitly set the libpath with the correct
    # command line argument in omnibus itself.
    config_hash["CC_LD_DYNPATH"] = "-R"
    config_hash["AR"] = "ar -X64"
    config_hash["NO_REGEX"] = "YesPlease"
  else
    # Linux things!
    config_hash["HAVE_PATHS_H"] = "YesPlease"
    config_hash["NO_R_TO_GCC_LINKER"] = "YesPlease"
  end

  # ensure that header files in git's source code are found first before looking in other directories
  # this solves an issue that occurs when libarchive has been built and installed and its archive.h header
  # file in #{install_dir}/embedded/include is accidentally picked up when compiling git
  env["CFLAGS"] = "-I. #{env["CFLAGS"]}"
  env["CPPFLAGS"] = "-I. #{env["CPPFLAGS"]}"
  env["CXXFLAGS"] = "-I. #{env["CXXFLAGS"]}"
  env["CFLAGS"] = "-std=c99 #{env["CFLAGS"]}"

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

  #
  # NOTE - If you run ./configure the environment variables set above will not be
  # used and only the command line args will be used. The issue with this is you
  # cannot specify everything on the command line that you can with the env vars.
  make "prefix=#{install_dir}/embedded -j #{workers}", env: env
  make "prefix=#{install_dir}/embedded install", env: env
end
