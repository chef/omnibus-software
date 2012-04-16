#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
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
version "5.9"

source :url => "http://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz",
       :md5 => "8cb9c412e5f2d96bc6f459aa8c6282a1"

relative_path "ncurses-5.9"

env = {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"}

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
  # build wide-character libraries
  command(["./configure",
           "--prefix=#{install_dir}/embedded",
           "--with-shared --with-termlib",
           "--without-debug",
           "--enable-widec"].join(" "),
          :env => env)
  command "make -j #{max_build_jobs}", :env => env
  command "make install", :env => env

  # build non-wide-character libraries
  command "make distclean"
  command(["./configure",
           "--prefix=#{install_dir}/embedded",
           "--with-shared --with-termlib",
           "--without-debug"].join(" "),
          :env => env)
  command "make -j #{max_build_jobs}", :env => env

  # installing the non-wide libraries will also install the non-wide
  # binaries, which doesn't happen to be a problem since we don't
  # utilize the ncurses binaries in private-chef (or oss chef)
  command "make install", :env => env
end
