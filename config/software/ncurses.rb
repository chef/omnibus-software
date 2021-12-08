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
default_version "6.2"

dependency "libgcc"
dependency "libtool" if ohai["platform"] == "aix"
dependency "config_guess"

source url: "http://ftp.gnu.org/gnu/ncurses/ncurses-6.2.tar.gz",
       sha256: "30306e0c76e0f9f1f0de987cf1c82a5c21e1ce6568b9227f7da5b71cbea86c9d",
       extract: :seven_zip

relative_path "ncurses-6.2"

env = with_embedded_path
env = with_standard_compiler_flags(env, aix: { use_gcc: true })

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
  license "MIT"
  license_file "https://gist.githubusercontent.com/remh/41a4f7433c77841c302c/raw/d15db09a192ca0e51022005bfb4c3a414a996896/ncurse.LICENSE"

  env.delete("CPPFLAGS")

  update_config_guess

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

  cmd_array << "--with-libtool" if ohai["platform"] == "aix"
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
  cmd_array << "--with-libtool" if ohai["platform"] == "aix"
  command(cmd_array.join(" "),
    env: env)
  command "make -j #{workers}", env: env

  # installing the non-wide libraries will also install the non-wide
  # binaries, which doesn't happen to be a problem since we don't
  # utilize the ncurses binaries in private-chef (or oss chef)
  command "make -j #{workers} install", env: env

  # Ensure embedded ncurses wins in the LD search path
  if ohai["platform"] == "smartos"
    link "#{install_dir}/embedded/lib/libcurses.so", "#{install_dir}/embedded/lib/libcurses.so.1"
  end
end
