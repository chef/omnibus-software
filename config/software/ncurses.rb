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

name "ncurses"
default_version "5.9"

dependency "libgcc"
dependency "libtool" if ohai['platform'] == "aix"

source url: "http://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz",
       md5: "8cb9c412e5f2d96bc6f459aa8c6282a1"

relative_path "ncurses-5.9"

env = with_embedded_path()
env = with_standard_compiler_flags(env, aix: { use_gcc: true })

if ohai['platform'] == "solaris2"
  # gcc4 from opencsw fails to compile ncurses
  env.merge!({"PATH" => "/opt/csw/gcc3/bin:/opt/csw/bin:/usr/local/bin:/usr/sfw/bin:/usr/ccs/bin:/usr/sbin:/usr/bin"})
  env.merge!({"CC" => "/opt/csw/gcc3/bin/gcc"})
  env.merge!({"CXX" => "/opt/csw/gcc3/bin/g++"})
end

# FIXME: validate omnibus-ruby sets this correctly on smartos now via with_standard_compiler_flagS()
#elsif ohai['platform'] == "smartos"
#  env.merge!({"LD_OPTIONS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib "})
#end

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
  ship_license "https://gist.githubusercontent.com/remh/41a4f7433c77841c302c/raw/d15db09a192ca0e51022005bfb4c3a414a996896/ncurse.LICENSE"
  env.delete('CPPFLAGS')

  if ohai['platform'] == "smartos"
    # SmartOS is Illumos Kernel, plus NetBSD userland with a GNU toolchain.
    # These patches are taken from NetBSD pkgsrc and provide GCC 4.7.0
    # compatibility:
    # http://ftp.netbsd.org/pub/pkgsrc/current/pkgsrc/devel/ncurses/patches/
    patch source: 'patch-aa', plevel: 0
    patch source: 'patch-ab', plevel: 0
    patch source: 'patch-ac', plevel: 0
    patch source: 'patch-ad', plevel: 0
    patch source: 'patch-cxx_cursesf.h', plevel: 0
    patch source: 'patch-cxx_cursesm.h', plevel: 0

    # Opscode patches - <someara@opscode.com>
    # The configure script from the pristine tarball detects xopen_source_extended incorrectly.
    # Manually working around a false positive.
    patch source: 'ncurses-5.9-solaris-xopen_source_extended-detection.patch', plevel: 0
  end

  if ohai['platform'] == "aix"
    patch source: 'patch-aix-configure', plevel: 0
  end

  if ohai['platform'] == "mac_os_x"
    # References:
    # https://github.com/Homebrew/homebrew-dupes/issues/43
    # http://invisible-island.net/ncurses/NEWS.html#t20110409
    #
    # Patches ncurses for clang compiler. Changes have been accepted into
    # upstream, but occurred shortly after the 5.9 release. We should be able
    # to remove this after upgrading to any release created after June 2012
    patch source: 'ncurses-clang.patch'
  end

  # build wide-character libraries
  cmd_array = ["./configure",
           "--prefix=#{install_dir}/embedded",
           "--with-shared",
           "--with-termlib",
           "--without-debug",
           "--without-normal", # AIX doesn't like building static libs
           "--without-cxx-binding",
           "--enable-overwrite",
           "--enable-widec"]

  cmd_array << "--with-libtool" if ohai['platform'] == 'aix'
  command(cmd_array.join(" "),
          env: env)
  command "make -j #{workers}", env: env
  command "make -j #{workers} install", env: env

  # build non-wide-character libraries
  command "make distclean"
  cmd_array = ["./configure",
           "--prefix=#{install_dir}/embedded",
           "--with-shared",
           "--with-termlib",
           "--without-debug",
           "--without-normal",
           "--without-cxx-binding",
           "--enable-overwrite"]
  cmd_array << "--with-libtool" if ohai['platform'] == 'aix'
  command(cmd_array.join(" "),
          env: env)
  command "make -j #{workers}", env: env

  # installing the non-wide libraries will also install the non-wide
  # binaries, which doesn't happen to be a problem since we don't
  # utilize the ncurses binaries in private-chef (or oss chef)
  command "make -j #{workers} install", env: env

  # Ensure embedded ncurses wins in the LD search path
  if ohai['platform'] == "smartos"
    link "#{install_dir}/embedded/lib/libcurses.so", "#{install_dir}/embedded/lib/libcurses.so.1"
  end
end
