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

name "ruby-jaym-fips"
default_version "2.0.0-p647"

# We only currently support 32-bit FIPS builds
if windows_arch_i386?
  relative_path "ruby-#{version}-i386-mingw32"
  source url: "https://s3-us-west-2.amazonaws.com/yakyakyak/ruby-#{version}-i386-mingw32.7z"

  version("2.0.0-p647") { source md5: "0b1e8f16580f26fd0992fad3834cb83d" }
end

build do
  copy "*", "#{install_dir}/embedded"
end
