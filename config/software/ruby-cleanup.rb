#
# Copyright:: Copyright (c) 2014-2018, Chef Software Inc.
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

#
# Common cleanup routines for ruby apps (InSpec, Workstation, Chef, etc)
#
name "ruby-cleanup"

license :project_license
skip_transitive_dependency_licensing true

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Clear the now-unnecessary git caches, cached gems, and git-checked-out gems
  block "Delete bundler git cache and git installs" do
    gemdir = shellout!("#{install_dir}/embedded/bin/gem environment gemdir", env: env).stdout.chomp
    remove_directory "#{gemdir}/cache"
# chef installs and ships with gems directly from git
#    remove_directory "#{gemdir}/bundler"
    remove_directory "#{gemdir}/doc"
  end

  # Clean up docs
  delete "#{install_dir}/embedded/docs"
  delete "#{install_dir}/embedded/share/man"
  delete "#{install_dir}/embedded/share/doc"
  delete "#{install_dir}/embedded/share/gtk-doc"
  delete "#{install_dir}/embedded/ssl/man"
  delete "#{install_dir}/embedded/man"
  delete "#{install_dir}/embedded/info"
end
