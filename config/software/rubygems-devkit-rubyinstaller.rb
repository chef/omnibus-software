#
# Copyright 2012-2016 Chef Software, Inc.
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

# Vendors rubyinstaller's devkit along with the latest rubygems.
# Do not depend on this software definition directly. You probably want to
# include rubygems-native instead.

name "rubygems-devkit-rubyinstaller"
default_version "0.0.1"

dependency "ruby"
dependency "rubygems"
dependency "devkit-rubyinstaller"
dependency "devkit-rubyinstaller-bash"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  embedded_dir = "#{install_dir}/embedded"

  command "echo - #{embedded_dir} > config.yml", cwd: embedded_dir
  ruby "dk.rb install", env: env, cwd: embedded_dir

  # TODO: Pull this code out into the libarchive/bsdtar software definition.

  # Normally we would symlink the required unix tools.
  # However with the introduction of git-cache to speed up omnibus builds,
  # we can't do that anymore since git on windows doesn't support symlinks.
  # https://groups.google.com/forum/#!topic/msysgit/arTTH5GmHRk
  # Therefore we copy the tools to the necessary places.
  # We need tar for 'knife cookbook site install' to function correctly and
  # many gems that ship with native extensions assume tar will be available
  # in the PATH.
  {
    'tar.exe'          => 'bsdtar.exe',
    'libarchive-2.dll' => 'libarchive-2.dll',
    'libexpat-1.dll'   => 'libexpat-1.dll',
    'liblzma-1.dll'    => 'liblzma-1.dll',
    'libbz2-2.dll'     => 'libbz2-2.dll',
    'libz-1.dll'       => 'libz-1.dll',
  }.each do |target, to|
    copy "#{install_dir}/embedded/mingw/bin/#{to}", "#{install_dir}/bin/#{target}"
  end
end
