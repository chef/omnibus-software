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

name "nagios"
default_version "3.3.1"

dependency "gd"
dependency "php"
dependency "spawn-fcgi"

source url: "https://downloads.sourceforge.net/project/nagios/nagios-3.x/nagios-3.3.1/nagios-3.3.1.tar.gz",
       sha256: "c4e39cd31a8a9ee814df848fd933b8611465f749b48432672aef4ae5849d9652"

relative_path "nagios"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
}

build do
  # configure it
  command(["./configure",
           "--prefix=#{install_dir}/embedded/nagios",
           "--with-nagios-user=opscode-nagios",
           "--with-nagios-group=opscode-nagios",
           "--with-command-group=opscode-nagios-cmd",
           "--with-command-user=opscode-nagios-cmd",
           "--with-gd-lib=#{install_dir}/embedded/lib",
           "--with-gd-inc=#{install_dir}/embedded/include",
           "--with-temp-dir=/var#{install_dir}/nagios/tmp",
           "--with-lockfile=/var#{install_dir}/nagios/lock",
           "--with-checkresult-dir=/var#{install_dir}/nagios/checkresult",
           "--with-mail=/usr/bin/mail"].join(" "),
    env: env)

  # so dome hacky shit
  command "sed -i 's:for file in includes/rss/\\*;:for file in includes/rss/\\*.\\*;:g' ./html/Makefile"
  command "sed -i 's:for file in includes/rss/extlib/\\*;:for file in includes/rss/extlib/\\*.\\*;:g' ./html/Makefile"
  # At build time, the users opscode-nagios-cmd and opscode-nagios do not exist.
  # Modify the makefile to replace those users with the current user.
  command "bash -c \"find . -name 'Makefile' | xargs sed -i 's:-o opscode-nagios-cmd -g opscode-nagios-cmd:-o $(whoami):g'\""
  command "bash -c \"find . -name 'Makefile' | xargs sed -i 's:-o opscode-nagios -g opscode-nagios:-o $(whoami):g'\""

  command "sudo chown -R $(whoami) /var/opt/opscode/nagios"

  # build it
  command "make -j #{workers} all", env: { "LD_RUN_PATH" => "#{install_dir}/embedded/lib" }
  command "make install"
  command "make install-config"
  command "make install-exfoliation"

  # clean up the install
  command "rm #{install_dir}/embedded/nagios/etc/*"

  # ensure the etc directory is avaialable on rebuild from git cache
  touch "#{install_dir}/embedded/nagios/etc/.gitkeep"
end
