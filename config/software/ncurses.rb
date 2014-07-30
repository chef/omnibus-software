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

name "ncurses"
default_version "5.9"

dependency "libgcc"
dependency "libtool" if Ohai['platform'] == "aix"

source url: "http://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz",
       md5: "8cb9c412e5f2d96bc6f459aa8c6282a1"

relative_path "ncurses-5.9"

########################################################################
#
# wide-character support:
# Ruby 1.9 optimistically builds against libncursesw for UTF-8
# support. In order to prevent Ruby from linking against a
# package-installed version of ncursesw, we build wide-character
# support into ncurses with the "--enable-widec" configure parameter.
# To support other applications and libraries that still try to link
# against libncurses, we also have to create non-wide libraries.
#
# The methods below are adapted from:
# http://www.linuxfromscratch.org/lfs/view/development/chapter06/ncurses.html
#
########################################################################

build do
  env = with_standard_compiler_flags(with_embedded_path, aix: { use_gcc: true })

  # gcc4 from opencsw fails to compile ncurses
  if Ohai["platform"] == "solaris2"
    env["PATH"] = "/opt/csw/gcc3/bin:/opt/csw/bin:/usr/local/bin:/usr/sfw/bin:/usr/ccs/bin:/usr/sbin:/usr/bin"
    env["CC"]   = "/opt/csw/gcc3/bin/gcc"
    env["CXX"]  = "/opt/csw/gcc3/bin/g++"
  end

  if Ohai["platform"] == "smartos"
    # SmartOS is Illumos Kernel, plus NetBSD userland with a GNU toolchain.
    # These patches are taken from NetBSD pkgsrc and provide GCC 4.7.0
    # compatibility:
    # http://ftp.netbsd.org/pub/pkgsrc/current/pkgsrc/devel/ncurses/patches/
    patch source: "patch-aa", plevel: 0
    patch source: "patch-ab", plevel: 0
    patch source: "patch-ac", plevel: 0
    patch source: "patch-ad", plevel: 0
    patch source: "patch-cxx_cursesf.h", plevel: 0
    patch source: "patch-cxx_cursesm.h", plevel: 0

    # Opscode patches - <someara@opscode.com>
    # The configure script from the pristine tarball detects xopen_source_extended incorrectly.
    # Manually working around a false positive.
    patch source: "ncurses-5.9-solaris-xopen_source_extended-detection.patch", plevel: 0
  end

  if Ohai["platform"] == "aix"
    patch source: "patch-aix-configure", plevel: 0
  end

  if Ohai["platform"] == "mac_os_x"
    # References:
    # https://github.com/Homebrew/homebrew-dupes/issues/43
    # http://invisible-island.net/ncurses/NEWS.html#t20110409
    #
    # Patches ncurses for clang compiler. Changes have been accepted into
    # upstream, but occurred shortly after the 5.9 release. We should be able
    # to remove this after upgrading to any release created after June 2012
    patch source: "ncurses-clang.patch"
  end

  # build wide-character libraries
  cmd = [
    "./configure",
    "--prefix=#{install_dir}/embedded",
    "--with-shared",
    "--with-termlib",
    "--without-debug",
    "--without-normal", # AIX doesn't like building static libs
    "--enable-overwrite",
    "--enable-widec",
  ]

  if Ohai["platform"] == "aix"
    cmd << "--with-libtool"
  end

  command cmd.join(" "), env: env
  command "make -j #{max_build_jobs}", env: env
  command "make -j #{max_build_jobs} install", env: env

  # Build non-wide-character libraries
  command "make distclean", env: env

  cmd = [
    "./configure",
    "--prefix=#{install_dir}/embedded",
    "--with-shared",
    "--with-termlib",
    "--without-debug",
    "--without-normal",
    "--enable-overwrite",
  ]

  if Ohai["platform"] == "aix"
    cmd << "--with-libtool"
  end

  command cmd.join(" "), env: env
  command "make -j #{max_build_jobs}", env: env

  # Installing the non-wide libraries will also install the non-wide
  # binaries, which doesn't happen to be a problem since we don't
  # utilize the ncurses binaries in private-chef (or oss chef)
  command "make -j #{max_build_jobs} install", env: env

  # Ensure embedded ncurses wins in the LD search path
  if Ohai["platform"] == "smartos"
    link "#{install_dir}/embedded/lib/libcurses.so", "#{install_dir}/embedded/lib/libcurses.so.1"
  end
end
