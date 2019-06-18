#
# Copyright:: Copyright (c) 2013-2014 Chef Software, Inc.
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

name "pip"
default_version "9.0.1"

skip_transitive_dependency_licensing true

dependency "setuptools"

source url: "https://github.com/pypa/pip/archive/#{version}.tar.gz",
       sha256: "d03fabbc4fbf2fbfc2f97307960aef2b3ca4c880ecda993dcc35957e33d7cd76",
       extract: :seven_zip

relative_path "pip-#{version}"

build do
  if ohai["platform"] == "windows"
    command "\"#{windows_safe_path(install_dir)}\\embedded\\python.exe\" setup.py install "\
            "--prefix=\"#{windows_safe_path(install_dir)}\\embedded\""
  else
    command "#{install_dir}/embedded/bin/python setup.py install --prefix=#{install_dir}/embedded"
  end
end
