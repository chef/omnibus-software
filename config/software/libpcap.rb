#
# Copyright:: Copyright (c) 2012-2014 Chef Software, Inc.
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

name "libpcap"
default_version "1.7.4"

version "1.7.4" do
  source sha256: "7ad3112187e88328b85e46dce7a9b949632af18ee74d97ffc3f2b41fe7f448b0"
end

source url: "https://www.tcpdump.org/release/libpcap-#{version}.tar.gz"

relative_path "libpcap-#{version}"

dependency "flex"
dependency "bison"

env = with_standard_compiler_flags

# build needs flex, which is built as a dependency
env["PATH"] = "#{install_dir}/embedded/bin" + File::PATH_SEPARATOR + ENV["PATH"]

build do
  license "BSD-3-Clause"
  license_file "https://gist.githubusercontent.com/truthbk/b06f2ea54f6f297c599e/raw/e1fc035d3114cd43e55fabcddd073e20307c129e/libpcap.license"
  command "./configure --prefix=#{install_dir}/embedded", env: env
  command "make -j #{workers}", env: env
  command "make -j #{workers} install", env: env
end
