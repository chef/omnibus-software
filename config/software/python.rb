#
# Copyright:: Copyright (c) 2013-2014 Chef Software, Inc.
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

name "python"
default_version "2.7.12"
dependency "ncurses"
dependency "zlib"
dependency "openssl"
dependency "bzip2"
dependency "libsqlite3"

source :url => "http://python.org/ftp/python/#{version}/Python-#{version}.tgz",
       :sha256 => '3cb522d17463dfa69a155ab18cffa399b358c966c0363d6c8b5b3bf1384da4b6'

relative_path "Python-#{version}"

env = {
  "CFLAGS" => "-I#{install_dir}/embedded/include -O3 -g -pipe",
  "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib"
}

python_configure = ["./configure",
                    "--enable-universalsdk=/",
                    "--prefix=#{install_dir}/embedded"]

if ohai['platform_family'] == 'mac_os_x'
  python_configure.push('--enable-ipv6',
                        '--with-universal-archs=intel',
                        '--enable-shared')
end

python_configure.push("--with-dbmliborder=")

build do
  ship_license "PSFL"
  patch :source => 'python-2.7.11-avoid-allocating-thunks-in-ctypes.patch' if linux?
  patch :source => 'python-2.7.11-fix-platform-ubuntu.diff' if linux?

  command python_configure.join(" "), :env => env
  command "make -j #{workers}", :env => env
  command "make install", :env => env
  delete "#{install_dir}/embedded/lib/python2.7/test"

  # There exists no configure flag to tell Python to not compile readline support :(
  block do
    FileUtils.rm_f(Dir.glob("#{install_dir}/embedded/lib/python2.7/lib-dynload/readline.*"))
  end
end
