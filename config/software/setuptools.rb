#
# Copyright 2013-2014 Chef Software, Inc.
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

name "setuptools"
default_version "0.7.7"

license "Python Software Foundation"
license_file "https://raw.githubusercontent.com/pypa/setuptools/master/LICENSE"
skip_transitive_dependency_licensing true

dependency "python"

version "0.9.8" do
  source md5: "243076241781935f7fcad370195a4291"
end

version "0.7.7" do
  source md5: "0d7bc0e1a34b70a97e706ef74aa7f37f"
end

version "20.0" do
  source md5: "fb22b2474ca037e0b08f3c3b293e02e6"
end

source url: "https://pypi.python.org/packages/source/s/setuptools/setuptools-#{version}.tar.gz"

relative_path "setuptools-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "#{install_dir}/embedded/bin/python setup.py install" \
          " --prefix=#{install_dir}/embedded", env: env
end
