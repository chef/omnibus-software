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

name "ruby"

# This is now the main software project for anything ruby related.
# Even if you want a pre-built version of ruby from ruby-installer, include
# this software as a dependency. It redirects to the appropriate "concrete"
# ruby software definition based on the requested build/platform configuration.
#
# By default, on windows, it vendors the prebuilt ruby from rubyinstaller.
# No devkit is provided by this package on windows. If you would like to vendor
# a compiler toolchain for a platform, either do so explicitly or use the
# rubygems-native software definition to pick a suitable one for you.
# For other platforms, it compiles a ruby using the available system toolchain.

if windows?
  default_version "rubyinstaller"
else
  default_version "compiled"
end

dependency "cacerts"

case version
when "rubyinstaller"
  dependency "ruby-rubyinstaller"
  dependency "openssl-windows"
when "jaym-fips"
  # This is a one-off build made by Jay and uploaded to S3 to support SAP
  # for the FIPS mode work the needed in 2015. Drop this as an option once we
  # are confident in our regular builds and no longer need to support the old
  # SAP build. The S3 bucket is named yakyakyak...  :)
  # This ruby build comes with openssl and the FIPS module. Don't clobber it.
  dependency "ruby-jaym-fips"
when "compiled"
  dependency "ruby-compiled"
  dependency "rb-readline" if windows?
else
  raise "Unknown ruby configuration #{version} - need one of [rubyinstaller|compiled|jaym-fips]"
end

dependency "openssl-customization"

