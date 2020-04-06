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
default_version "20.0.2"

skip_transitive_dependency_licensing true

dependency "setuptools"

source url: "https://github.com/pypa/pip/archive/#{version}.tar.gz",
       extract: "seven_zip"

version("19.1.1") { source sha256: "cce3a3a4cc6f7e1f1d52d0dbe843ebca153ee42660a01acd9248d110c374efa2" }
version("19.3.1") { source sha256: "f12b7a6be2dbbfeefae5f14992c89175ef72ce0fe96452b4f66be855a12841ff" }
version("20.0.2") { source sha256: "00bdc118df4552f654a5ccf0bd3ff1a7d101ee7d7ac899fe9a752363b3f2f070" }

relative_path "pip-#{version}"

build do
  if ohai["platform"] == "windows"
    command "\"#{windows_safe_path(install_dir)}\\embedded\\python.exe\" setup.py install "\
            "--prefix=\"#{windows_safe_path(install_dir)}\\embedded\""
  else
    command "#{install_dir}/embedded/bin/python setup.py install --prefix=#{install_dir}/embedded"
  end
end