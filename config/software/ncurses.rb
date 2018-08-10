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

license "MIT"
license_file "http://invisible-island.net/ncurses/ncurses-license.html"
license_file "http://invisible-island.net/ncurses/ncurses.faq.html"
skip_transitive_dependency_licensing true

dependency "libtool" if aix?
dependency "config_guess"
dependency "patch" if solaris_10?

version("5.9") { source md5: "8cb9c412e5f2d96bc6f459aa8c6282a1", url: "https://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz" }
version("5.9-20150530") { source md5: "bb2cbe1d788d3ab0138fc2734e446b43", url: "ftp://invisible-island.net/ncurses/current/ncurses-5.9-20150530.tgz" }
version("6.0-20150613") { source md5: "0c6a0389d004c78f4a995bc61884a563", url: "ftp://invisible-island.net/ncurses/current/ncurses-6.0-20150613.tgz" }
version("6.0-20150810") { source md5: "78bfcb4634a87b4cda390956586f8f1f", url: "ftp://invisible-island.net/ncurses/current/ncurses-6.0-20150810.tgz" }

relative_path "ncurses-#{version}"

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
  env = with_standard_compiler_flags(with_embedded_path)
  env.delete("CPPFLAGS")

  if smartos?
    # SmartOS is Illumos Kernel, plus NetBSD userland with a GNU toolchain.
    # These patches are taken from NetBSD pkgsrc and provide GCC 4.7.0
    # compatibility:
    # http://ftp.netbsd.org/pub/pkgsrc/current/pkgsrc/devel/ncurses/patches/
    patch source: "patch-aa", plevel: 0, env: env
    patch source: "patch-ab", plevel: 0, env: env
    patch source: "patch-ac", plevel: 0, env: env
    patch source: "patch-ad", plevel: 0, env: env
    patch source: "patch-cxx_cursesf.h", plevel: 0, env: env
    patch source: "patch-cxx_cursesm.h", plevel: 0, env: env

    # Chef patches - <sean@sean.io>
    # The configure script from the pristine tarball detects xopen_source_extended incorrectly.
    # Manually working around a false positive.
    patch source: "ncurses-5.9-solaris-xopen_source_extended-detection.patch", plevel: 0, env: env
  end

  update_config_guess

  # AIX's old version of patch doesn't like the patches here
  unless aix?
    if version == "5.9"
      # Patch to add support for GCC 5, doesn't break previous versions
      patch source: "ncurses-5.9-gcc-5.patch", plevel: 1, env: env
    end
  end

  if mac_os_x? ||
    # Clang became the default compiler in FreeBSD 10+
      (freebsd? && ohai["os_version"].to_i >= 1000024)
    # References:
    # https://github.com/Homebrew/homebrew-dupes/issues/43
    # http://invisible-island.net/ncurses/NEWS.html#t20110409
    #
    # Patches ncurses for clang compiler. Changes have been accepted into
    # upstream, but occurred shortly after the 5.9 release. We should be able
    # to remove this after upgrading to any release created after June 2012
    patch source: "ncurses-clang.patch", env: env
  end

  if openbsd?
    patch source: "patch-ncurses_tinfo_lib__baudrate.c", plevel: 0, env: env
  end

  configure_command = [
    "./configure",
    "--prefix=#{install_dir}/embedded",
    "--enable-overwrite",
    "--with-shared",
    "--with-termlib",
    "--without-ada",
    "--without-cxx-binding",
    "--without-debug",
    "--without-manpages",
  ]

  if aix?
    # AIX kinda needs 5.9-20140621 or later
    # because of a naming snafu in shared library naming.
    # see http://invisible-island.net/ncurses/NEWS.html#t20140621

    # let libtool deal with library silliness
    configure_command << "--with-libtool=\"#{install_dir}/embedded/bin/libtool\""

    # stick with just the shared libs on AIX
    configure_command << "--without-normal"

    # ncurses's ./configure incorrectly
    # "figures out" ARFLAGS if you try
    # to set them yourself
    env.delete("ARFLAGS")

    # use gnu install from the coreutils IBM rpm package
    env["INSTALL"] = "/opt/freeware/bin/install"
  end

  # only Solaris 10 sh has a problem with
  # parens enclosed case statement conditions the configure script
  configure_command.unshift "bash" if solaris_10?

  command configure_command.join(" "), env: env

  # unfortunately, libtool may try to link to libtinfo
  # before it has been assembled; so we have to build in serial
  make "libs", env: env if aix?

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env

  # Build non-wide-character libraries
  make "distclean", env: env
  configure_command << "--enable-widec"

  command configure_command.join(" "), env: env
  make "libs", env: env if aix?
  make "-j #{workers}", env: env

  # Installing the non-wide libraries will also install the non-wide
  # binaries, which doesn't happen to be a problem since we don't
  # utilize the ncurses binaries in private-chef (or oss chef)
  make "-j #{workers} install", env: env

  # Ensure embedded ncurses wins in the LD search path
  if smartos?
    link "#{install_dir}/embedded/lib/libcurses.so", "#{install_dir}/embedded/lib/libcurses.so.1"
  end
end
