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
# expeditor/ignore: deprecated 2021-04

name "rubygems"

license "MIT"
license_file "https://raw.githubusercontent.com/rubygems/rubygems/master/LICENSE.txt"
skip_transitive_dependency_licensing true

dependency "ruby"

if version && !source
  known_tarballs = {
    "2.4.1" => "7e39c31806bbf9268296d03bd97ce718",
    "2.4.4" => "440a89ad6a3b1b7a69b034233cc4658e",
    "2.4.5" => "5918319a439c33ac75fbbad7fd60749d",
    "2.4.8" => "dc77b51449dffe5b31776bff826bf559",
    "2.6.7" => "9cd4c5bdc70b525dfacd96e471a64605",
    "2.6.8" => "40b3250f28c1d0d5cb9ff5ab2b17df6e",
  }
  known_tarballs.each do |vsn, md5|
    version vsn do
      source md5: md5, url: "https://rubygems.org/rubygems/rubygems-#{vsn}.tgz"
      relative_path "rubygems-#{vsn}"
    end
  end
end

# If we still don't have a source (if it's a tarball) grab from ruby ...
if version && !source
  # If the version is a gem version, we"ll just be using rubygems.
  # If it's a branch or SHA (i.e. v1.2.3) we use github.
  begin
    Gem::Version.new(version)
  rescue ArgumentError
    source git: "https://github.com/rubygems/rubygems.git"
  end
end

# git repo is always expanded to "rubygems"
if source && source.include?(:git)
  relative_path "rubygems"
end

build do
  env = with_standard_compiler_flags(with_embedded_path)

  if source
    # Building from source:
    command "git submodule init", env: env
    command "git submodule update", env: env
    ruby "setup.rb  --no-document", env: env
  else
    # Installing direct from rubygems:
    # If there is no version, this will get latest.
    gem "update --no-document --system #{version}", env: env
    gem "uninstall rubygems-update -ax"
  end
end
