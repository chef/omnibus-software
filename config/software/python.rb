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
default_version "2.7.5"

dependency "gdbm"
dependency "ncurses"
dependency "zlib"
dependency "openssl"
dependency "bzip2"

source :url => "http://python.org/ftp/python/#{version}/Python-#{version}.tgz",
       :md5 => 'b4f01a1d0ba0b46b05c73b2ac909b1df'

relative_path "Python-#{version}"

extra_cflags = ''
extra_configure_options = '--enable-shared'

if mac_os_x_mavericks?
  extra_cflags = '-std=gnu89 -fheinous-gnu-extensions'
  extra_configure_options = '--without-gcc'
end

env = {
  "CC" => "gcc -fPIC",
  "CFLAGS" => "-I#{install_dir}/embedded/include -O3 -g -pipe #{extra_cflags}",
  "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib"
}
env.merge!('MACOSX_DEPLOYMENT_TARGET' => '10.9') if mac_os_x_mavericks?

build do
  command ["./configure",
           "--prefix=#{install_dir}/embedded",
           extra_configure_options,
           "--with-dbmliborder=gdbm"].join(" "), :env => env
  command "make", :env => env
  command "make install", :env => env

  block do
    # There exists no configure flag to tell Python to not compile readline support :(
    FileUtils.rm_f(Dir.glob("#{install_dir}/embedded/lib/python2.7/lib-dynload/readline.*"))
    # Remove unused extension which is known to make health checks fail on CentOS 6.
    FileUtils.rm_f(Dir.glob("#{install_dir}/embedded/lib/python2.7/lib-dynload/_bsddb.*"))
  end
end
