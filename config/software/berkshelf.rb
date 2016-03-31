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

name "berkshelf"
default_version "master"

license "Apache-2.0"
license_file "LICENSE"

source git: "https://github.com/berkshelf/berkshelf.git"

relative_path "berkshelf"

dependency "ruby"
dependency "rubygems"

unless windows? && (project.overrides[:ruby].nil? || project.overrides[:ruby][:version] == "ruby-windows")
  dependency "libarchive"
end

dependency "nokogiri"
dependency "bundler"
dependency "dep-selector-libgecode"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  gemfile = "#{project_dir}/Gemfile"

  block do
    require 'fileutils'
    if File.exist?(gemfile)
      open(gemfile, 'a') { |f| f.puts "gem 'net-ssh', '= 3.0.2'" }
    end
  end

  bundle "lock --update net-ssh", env: env
  bundle "install" \
         " --jobs #{workers}" \
         " --without guard", env: env

  bundle "exec thor gem:build", env: env

  gem "install pkg/berkshelf-*.gem" \
      " --no-ri --no-rdoc", env: env
end
