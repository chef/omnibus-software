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

# Installs rubygems with a some way of building native gems on any
# supported platform.
# By default, on windows, this vendors devkit from rubyinstaller.
# By default, on any other OS, this depends on the native compiler toolchain
# present in that OS. Nothing is specifically vendored.
#
# If you are writing a software definition that builds native gems anywhere
# in its dependency chain, you must include rubygems-native instead of rubygems
# unless you include dependency to a software definition that explicitly builds
# the correct version of that native gem and it depends on rubygems-native.
# As an example, if you are a software definition for a gem that needs nokogiri,
# you must either depend on rubygems-native or you must depend on nokogiri
# (which itself depends on rubygems-native and builds nokogiri correctly).

name "rubygems-native"

if windows?
  default_version "devkit-rubyinstaller"
else
  default_version "system-default"
end

case version
when "devkit-rubyinstaller"
  dependency "rubygems-devkit-rubyinstaller"
when "mingw"
  dependency "rubygems-mingw"
when "system-default"
  dependency "ruby"
  dependency "rubygems"
else
  raise "Unknown rubygems-native configuration - version must be [devkit-rubyinstaller|mingw|system-default]"
end
