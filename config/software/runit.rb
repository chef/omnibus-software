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

name "runit"
default_version "2.1.1"

source url: "http://smarden.org/runit/runit-#{version}.tar.gz",
       md5: "8fa53ea8f71d88da9503f62793336bc3"

relative_path "admin/runit-#{version}/src"

build do
  working_dir = "#{project_dir}/runit-#{version}"

  Dir.chdir(working_dir) do
    # Put runit where we want it, not where they tell us to
    command 'sed -i -e "s/^char\ \*varservice\ \=\"\/service\/\";$/char\ \*varservice\ \=\"' + install_dir.gsub("/", "\\/") + '\/service\/\";/" src/sv.c'

    # TODO: the following is not idempotent
    command "sed -i -e s:-static:: src/Makefile"
  end

  # Build it
  Dir.chdir("#{working_dir}/src") do
    command "make"
    command "make check"
  end

  # Move it
  mkdir "#{install_dir}/embedded/bin"
  copy "#{working_dir}/src/chpst", "#{install_dir}/embedded/bin"
  copy "#{working_dir}/src/runit", "#{install_dir}/embedded/bin"
  copy "#{working_dir}/src/runit-init", "#{install_dir}/embedded/bin"
  copy "#{working_dir}/src/runsv", "#{install_dir}/embedded/bin"
  copy "#{working_dir}/src/runsvchdir", "#{install_dir}/embedded/bin"
  copy "#{working_dir}/src/runsvdir", "#{install_dir}/embedded/bin"
  copy "#{working_dir}/src/sv", "#{install_dir}/embedded/bin"
  copy "#{working_dir}/src/svlogd", "#{install_dir}/embedded/bin"
  copy "#{working_dir}/src/utmpset", "#{install_dir}/embedded/bin"

  erb source: "runsvdir-start.erb",
      dest: "#{install_dir}/embedded/bin/runsvdir-start",
      mode: 0755,
      vars: { install_dir: install_dir }

  # Setup service directories
  touch "#{install_dir}/service/.gitkeep"
  touch "#{install_dir}/sv/.gitkeep"
  touch "#{install_dir}/init/.gitkeep"
end
