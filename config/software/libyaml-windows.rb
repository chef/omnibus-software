#
# Copyright:: Copyright (c) 2014 Opscode, Inc.
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
# libyaml 0.1.5 fixes a security vulnerability to 0.1.4.
# Since the rubyinstaller.org doesn't release ruby when a dependency gets
# patched, we are manually patching the dependency until we get a new
# ruby release on windows.
# See: https://github.com/oneclick/rubyinstaller/issues/210
# This component should be removed when libyaml 0.1.5 ships with ruby builds
# of rubyinstaller.org
#
name "libyaml-windows"
default_version "0.1.7"

version "0.1.7" do
  source sha256: "c90f4a678a7901bf0c48fc50cd6ffbd96eeb0b0184ba6c853fc0f54702213674"
end

source :url => "https://s3.amazonaws.com/dd-agent/libyaml-#{version}-x64-windows.tar.lzma",
       :extract => :seven_zip

build do
  temp_directory = File.join(Omnibus::Config.cache_dir, "libyaml-cache")

  # Ensure the directory exists
  mkdir temp_directory
  # First extract the tar file out of lzma archive.
  command "7z.exe x #{project_file} -o#{temp_directory} -r -y"
  # Now extract the files out of tar archive.
  command "7z.exe x #{File.join(temp_directory, "libyaml-#{version}-x64-windows.tar")} -o#{temp_directory} -r -y"
  # Now copy over libyaml-0-2.dll to the build dir
  copy("#{temp_directory}/bin/libyaml-0-2.dll", "#{install_dir}/embedded/bin/libyaml-0-2.dll")
end
