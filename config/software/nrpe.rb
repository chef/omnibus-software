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

name "nrpe"
version "2.14"

dependency "zlib"
dependency "openssl"
dependency "libwrap" unless platform == 'mac_os_x'

# tarball location comes from sourceforge download redirect
source :url => "http://downloads.sourceforge.net/project/nagios/nrpe-2.x/#{name}-#{version}/#{name}-#{version}.tar.gz",
       :md5 => "105857720e21674083a6d6be99e102c7"

relative_path "#{name}-#{version}"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -DNODAEMON=1",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
  "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}"
}

build do
  # TODO: OMG THIS IS HORRIBLE
  command "sed -i 's:\\r::g' ./src/nrpe.c"

  patch :source => "fix_for_runit.patch",
        :target => "./src/nrpe.c"

  # configure it
  command(["./configure",
           "--prefix=#{install_dir}/embedded",
           "--with-ssl=#{install_dir}/embedded",
           "--with-ssl-lib=#{install_dir}/embedded/lib",
           "--with-ssl-inc=#{install_dir}/embedded/include"].join(" "),
          :env => env)

  # build it
  command "make all", :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"}

  # move it
  command "mkdir -p #{install_dir}/embedded/nagios/libexec"
  command "mkdir -p #{install_dir}/embedded/nagios/bin"
  command "install -m 0755 ./src/check_nrpe #{install_dir}/embedded/nagios/libexec"
  command "install -m 0755 ./src/nrpe #{install_dir}/embedded/nagios/bin"
end
