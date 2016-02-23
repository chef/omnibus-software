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

name "devkit-rubyinstaller-bash"
default_version "3.1.23-4-msys-1.0.18"

dependency "devkit-rubyinstaller"
source url: "https://github.com/opscode/msys-bash/releases/download/bash-#{version}/bash-#{version}-bin.tar.lzma",
       md5: "22d5dbbd9bd0b3e0380d7a0e79c3108e"

relative_path 'bin'

build do
  # Copy over the required bins into embedded/bin
  ["bash.exe", "sh.exe"].each do |exe|
    copy "#{exe}", "#{install_dir}/embedded/bin/#{exe}"
  end
end
