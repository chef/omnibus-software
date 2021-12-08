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

name "setuptools-py3"
default_version "28.8.0"

dependency "python3"

relative_path "setuptools-#{version}"

source url: "https://github.com/pypa/setuptools/archive/v#{version}.tar.gz",
       sha256: "d3b2c63a5cb6816ace0883bc3f6aca9e7890c61d80ac0d608a183f85825a7cc0"

build do
  python_path = "#{install_dir}/embedded/bin/python"
  if ohai["platform"] == "windows"
    python_path = "#{windows_safe_path(python_3_embedded)}\\python.exe"
  end

  license "Python-2.0"
  command "#{python_path} bootstrap.py"
  command "#{python_path} setup.py install --prefix=#{windows_safe_path(python_3_embedded)}"
end
