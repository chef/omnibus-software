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

name "runit"
default_version "2.1.1"

source url: "https://smarden.org/runit/runit-2.1.1.tar.gz",
       sha256: "ffcf2d27b32f59ac14f2d4b0772a3eb80d9342685a2042b7fbbc472c07cf2a2c"

relative_path "admin"

working_dir = "#{project_dir}/runit-2.1.1"

build do
  # put runit where we want it, not where they tell us to
  command 'sed -i -e "s/^char\ \*varservice\ \=\"\/service\/\";$/char\ \*varservice\ \=\"' + install_dir.gsub("/", "\\/") + '\/service\/\";/" src/sv.c', cwd: working_dir
  # TODO: the following is not idempotent
  command "sed -i -e s:-static:: src/Makefile", cwd: working_dir

  # build it
  command "make -j #{workers}", cwd: "#{working_dir}/src"
  command "make check", cwd: "#{working_dir}/src"

  # move it
  mkdir "#{install_dir}/embedded/bin"
  ["src/chpst",
   "src/runit",
   "src/runit-init",
   "src/runsv",
   "src/runsvchdir",
   "src/runsvdir",
   "src/sv",
   "src/svlogd",
   "src/utmpset"].each do |bin|
     copy "#{bin}", "#{install_dir}/embedded/bin", cwd: working_dir
   end

  block do
    open("#{install_dir}/embedded/bin/runsvdir-start", "w") do |file|
      file.print <<~EOH
        #!/bin/bash
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

        PATH=#{install_dir}/bin:#{install_dir}/embedded/bin:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin

        # enforce our own ulimits

        ulimit -c 0
        ulimit -d unlimited
        ulimit -e 0
        ulimit -f unlimited
        ulimit -i 62793
        ulimit -l 64
        ulimit -m unlimited
        # WARNING: increasing the global file descriptor limit increases RAM consumption on startup dramatically
        ulimit -n 50000
        ulimit -q 819200
        ulimit -r 0
        ulimit -s 10240
        ulimit -t unlimited
        ulimit -u unlimited
        ulimit -v unlimited
        ulimit -x unlimited
        echo "1000000" > /proc/sys/fs/file-max

        # and our ulimit

        umask 022

        exec env - PATH=$PATH \
        runsvdir -P #{install_dir}/service 'log: ...........................................................................................................................................................................................................................................................................................................................................................................................................'
      EOH
    end
  end

  command "chmod 755 #{install_dir}/embedded/bin/runsvdir-start"

  # set up service directories
  block do
    ["#{install_dir}/service",
     "#{install_dir}/sv",
     "#{install_dir}/init"].each do |dir|
       FileUtils.mkdir_p(dir)
      # make sure cached builds include this dir
       FileUtils.touch(File.join(dir, ".gitkeep"))
     end
  end
end
