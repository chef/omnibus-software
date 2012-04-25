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

name "runit"
version "2.1.1"

source :url => "http://smarden.org/runit/runit-2.1.1.tar.gz",
       :md5 => "8fa53ea8f71d88da9503f62793336bc3"

relative_path "admin"

working_dir = "#{project_dir}/runit-2.1.1"

build do
  # put runit where we want it, not where they tell us to
  command 'sed -i -e "s/^char\ \*varservice\ \=\"\/service\/\";$/char\ \*varservice\ \=\"\/opt\/' + project.name + '\/service\/\";/" src/sv.c', :cwd => working_dir
  # TODO: the following is not idempotent
  command "sed -i -e s:-static:: src/Makefile", :cwd => working_dir

  # build it
  command "make", :cwd => "#{working_dir}/src"
  command "make check", :cwd => "#{working_dir}/src"

  # move it
  command "mkdir -p #{install_dir}/embedded/bin"
  ["src/chpst",
   "src/runit",
   "src/runit-init",
   "src/runsv",
   "src/runsvchdir",
   "src/runsvdir",
   "src/sv",
   "src/svlogd",
   "src/utmpset"].each do |bin|
    command "cp #{bin} #{install_dir}/embedded/bin", :cwd => working_dir
  end

  files_dir = File.expand_path("files/runit", Omnibus.root)
  command "#{install_dir}/embedded/bin/rsync -a #{files_dir}/runsvdir-start #{install_dir}/embedded/bin/runsvdir-start"

  # set up service directories
  ["#{install_dir}/service",
   "#{install_dir}/sv",
   "#{install_dir}/init"].each do |dir|
    command "mkdir -p #{dir}"
  end
end
