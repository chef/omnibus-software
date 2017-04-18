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

name "test-kitchen"
default_version "master"
relative_path "test-kitchen"

source git: "https://github.com/test-kitchen/test-kitchen.git"

dependency "ruby"
dependency "rubygems"
dependency "nokogiri"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  gemfile = "#{project_dir}/Gemfile"
  tmp_gemfile = "#{gemfile}_old"

  block do
    # make sure test-kitchen build honors chef constraints
    require "fileutils"
    FileUtils.cp(gemfile, tmp_gemfile)
    chef_gem_line = "gem \"chef\", path: \"../../chef/chef\""
    unless IO.readlines(gemfile)[-1] =~ /#{chef_gem_line}/
      open(gemfile, "a") { |f| f.puts chef_gem_line }
    end
  end

  bundle "install --without guard integration", env: env

  block do
    File.delete(gemfile)
    File.rename(tmp_gemfile, gemfile)
  end

  bundle "exec rake build", env: env

  gem "install pkg/test-kitchen-*.gem" \
      " --no-ri --no-rdoc", env: env
end
