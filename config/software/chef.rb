#
# Copyright 2012-2018, Chef Software Inc.
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
name "chef"
default_version "v13.10.4"

license "Apache-2.0"
license_file "LICENSE"

# Grab accompanying notice file.
# So that Open4/deep_merge/diff-lcs disclaimers are present in Omnibus LICENSES tree.
license_file "NOTICE"

# For the specific super-special version "local_source", build the source from
# the local git checkout. This is what you'd want to occur by default if you
# just ran omnibus build locally.
version("local_source") do
  source path: "#{project.files_path}/../..",
         # Since we are using the local repo, we try to not copy any files
         # that are generated in the process of bundle installing omnibus.
         # If the install steps are well-behaved, this should not matter
         # since we only perform bundle and gem installs from the
         # omnibus cache source directory, but we do this regardless
         # to maintain consistency between what a local build sees and
         # what a github based build will see.
         options: { exclude: [ "omnibus/vendor" ] }
end

# For any version other than "local_source", fetch from github.
# This is the behavior the transitive omnibus software deps such as chef-dk
# expect.
if version != "local_source"
  source git: "https://github.com/chef/chef.git"
end

relative_path "chef"

dependency "ruby"
dependency "rubygems"
dependency "bundler"
dependency "ohai"
dependency "appbundler"
dependency "libarchive" # for archive resource

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # compiled ruby on windows 2k8R2 x86 is having issues compiling
  # native extensions for pry-byebug so excluding for now
  excluded_groups = %w{server docgen maintenance pry travis integration ci}
  excluded_groups << "ruby_prof" if aix?
  excluded_groups << "ruby_shadow" if aix?

  # install the whole bundle first
  bundle "install --without #{excluded_groups.join(' ')}", env: env

  # use the rake install task to build/install chef-config
  bundle "exec rake install", env: env

  gemspec_name = windows? ? "chef-universal-mingw32.gemspec" : "chef.gemspec"

  # This step will build native components as needed - the event log dll is
  # generated as part of this step.  This is why we need devkit.
  gem "build #{gemspec_name}", env: env

  # ensure we put the gems in the right place to get picked up by the publish scripts
  delete "pkg"
  mkdir "pkg"
  copy "chef*.gem", "pkg"

  # Always deploy the powershell modules in the correct place.
  if windows?
    mkdir "#{install_dir}/modules/chef"
    copy "distro/powershell/chef/*", "#{install_dir}/modules/chef"
  end

  appbundle "chef", env: env
  appbundle "ohai", env: env
end
