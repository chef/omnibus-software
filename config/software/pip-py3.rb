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

name "pip-py3"

default_version "10.0.1"

dependency "setuptools-py3"

source url: "https://github.com/pypa/pip/archive/#{version}.tar.gz",
       sha256: "2c39367b8529f50746b399d7e4563df48a148b8558ae6f7236b51c155359365a",
       extract: :seven_zip

relative_path "pip-#{version}"

build do
  license "MIT"
  license_file "https://raw.githubusercontent.com/pypa/pip/develop/LICENSE.txt"
  if ohai["platform"] == "windows"
    command "\"#{windows_safe_path(python_3_embedded)}\\python.exe\" setup.py install "\
            "--prefix=\"#{windows_safe_path(python_3_embedded)}\""
  else
    command "#{python_3_embedded}/bin/python setup.py install --prefix=#{python_2_embedded}"
  end
end
