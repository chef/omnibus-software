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
default_version "1.0.20"

version("1.0.20") { source url: "https://github.com/jdmundrawala/zeromq4-x/releases/download/libzmq4x-v#{version}/libzmq4.zip",
                           md5: "dcdb1607896577444adaf9bd49effb0e" }

build do
  env = with_standard_compiler_flags(with_embedded_path)

  tmpdir = File.join(Omnibus::Config.cache_dir, "libzmq-cache")

  command "7z.exe x #{project_file} -o#{tmpdir}", env: env

  copy "#{tmpdir}/bin/*", "#{install_dir}/embedded/bin"
  copy "#{tmpdir}/include/*", "#{install_dir}/embedded/include"
  copy "#{tmpdir}/lib/*", "#{install_dir}/embedded/lib"

  # Ensure the main DLL is available under a well known name.
  copy "#{tmpdir}/bin/libzmq-mt-4_0_6.dll", "#{install_dir}/embedded/bin/libzmq.dll"
end
