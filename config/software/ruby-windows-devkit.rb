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

name "ruby-windows-devkit"
default_version "4.7.2-20130224"

dependency "ruby-windows"

if windows_arch_i386?
  version "4.7.2-20130224" do
    source url: "http://cdn.rubyinstaller.org/archives/devkits/DevKit-mingw64-32-#{version}-1151-sfx.exe",
           md5: "9383f12958aafc425923e322460a84de"
  end
else
  version "4.7.2-20130224" do
    source url: "http://cdn.rubyinstaller.org/archives/devkits/DevKit-mingw64-64-#{version}-1432-sfx.exe",
           md5: "ce99d873c1acc8bffc639bd4e764b849"
  end
end
build do
  env = with_standard_compiler_flags(with_embedded_path)

  embedded_dir = "#{install_dir}/embedded"

  version "4.7.2-20130224" do
    command "#{project_file} -y -o#{windows_safe_path(embedded_dir)}", env: env
  end


  command "echo - #{install_dir}/embedded > config.yml", cwd: embedded_dir
  ruby "dk.rb install", env: env, cwd: embedded_dir

  # many gems that ship with native extensions assume tar will be available in the PATH
  copy "#{install_dir}/embedded/mingw/bin/bsdtar.exe", "#{install_dir}/embedded/mingw/bin/tar.exe"
end
