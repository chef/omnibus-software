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

name "libzmq4x-windows"
default_version "1.0.21"

# Longer term we need to move this to a chef internal build pipeline
# https://github.com/jdmundrawala/zeromq4-x/releases/download/libzmq4x-1.0.21/libzmq4x-windows.zip
#
version("1.0.21") do
  source url: "https://github.com/jdmundrawala/zeromq4-x/releases/download/libzmq4x-#{version}/libzmq4x-windows.zip",
         md5: "f75bb49580c7563f890d1fcfdd415553"
end

build do
  tmpdir = File.join(Omnibus::Config.source_dir, "libzmq4x-windows")

  copy "#{tmpdir}/bin/*", "#{install_dir}/embedded/bin"
  copy "#{tmpdir}/include/*", "#{install_dir}/embedded/include"
  copy "#{tmpdir}/lib/*", "#{install_dir}/embedded/lib"

  # Ensure the main DLL is available under a well known name.
  copy "#{tmpdir}/bin/libzmq-mt-4_0_6.dll", "#{install_dir}/embedded/bin/libzmq.dll"
end
