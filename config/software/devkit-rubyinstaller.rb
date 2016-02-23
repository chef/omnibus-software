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

# Brings you a compiler toolchain from Ruby's devkit.
# It is not recommended that you depend on this software definition directly.
# It only works on windows and is not very general. If you simply need some
# platform appropriate toolchain, you should use the build-essentials cookbook
# to fetch such a toolchain for your builder and put it in the path. If you
# actively wish to vendor a toolchain (say for rubygems), you should look at
# rubygems-native.rb instead.

name "devkit-rubyinstaller"
default_version "4.7.2-20130224"

if windows_arch_i386?
  version "4.5.2-20111229-1559" do
    source url: "http://cloud.github.com/downloads/oneclick/rubyinstaller/DevKit-tdm-32-#{version}-sfx.exe",
           md5: "4bf8f2dd1d582c8733a67027583e19a6"
  end

  version "4.7.2-20130224" do
    source url: "http://cdn.rubyinstaller.org/archives/devkits/DevKit-mingw64-32-#{version}-1151-sfx.exe",
           md5: "9383f12958aafc425923e322460a84de"
  end

  version "4.7.2-20130224-1151" do
    source url: "http://cdn.rubyinstaller.org/archives/devkits/DevKit-mingw64-32-#{version}-sfx.exe",
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
  command "#{project_file} -y -o#{windows_safe_path(embedded_dir)}", env: env
end
