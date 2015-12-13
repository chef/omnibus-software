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

name "setuptools"
default_version "0.7.7"

dependency "python"


relative_path "setuptools-#{version}"

if ohai['platform'] == 'windows'
  # FIXME: this file changes, which breaks the build. Let's put it on S3
  source :url => 'https://bootstrap.pypa.io/ez_setup.py',
         :md5 => 'aa20494c72280f16698de6cb02631e8f'

  build do
    command "\"#{windows_safe_path(install_dir)}\\embedded\\python.exe\" ez_setup.py "
  end
else
  source :url => "https://pypi.python.org/packages/source/s/setuptools/setuptools-#{version}.tar.gz",
         :md5 => '0d7bc0e1a34b70a97e706ef74aa7f37f'
  build do
    ship_license "PSFL"
    command "#{install_dir}/embedded/bin/python setup.py install --prefix=#{install_dir}/embedded"
  end
end
