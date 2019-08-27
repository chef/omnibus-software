#
# Copyright 2016-2019 Chef Software, Inc.
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

name "rust"
default_version "1.32.0"

license "Apache-2.0"
license_file "LICENSE-APACHE"

# Nightly releases use a slighty different URL and TARBALL naming convention
if version =~ /\d{4}-\d{2}-\d{2}/
  relative_path_template = "rust-nightly-%{arch}-%{host_triple}"
  url_template = "https://static.rust-lang.org/dist/#{version}/rust-nightly-%{arch}-%{host_triple}.tar.gz"
else
  relative_path_template = "rust-#{version}-%{arch}-%{host_triple}"
  url_template = "https://static.rust-lang.org/dist/rust-#{version}-%{arch}-%{host_triple}.tar.gz"
end

# Default architecture is x86_64
arch = "x86_64"

if windows?
  host_triple = "pc-windows-gnu"

  if windows_arch_i386?
    arch = "i686"

    version "1.32.0" do
      source sha256: "226b00e61095fe1b8a7f1f186087731a294235b4da53601b709517ca9dc624f0",
             url: url_template % { host_triple: host_triple, arch: arch }
    end
  else
    version "1.32.0" do
      source sha256: "358e1435347c67dbf33aa9cad6fe501a833d6633ed5d5aa1863d5dffa0349be9",
             url: url_template % { host_triple: host_triple, arch: arch }
    end
  end

elsif mac_os_x?
  host_triple = "apple-darwin"

  version "1.32.0" do
    source sha256: "f0dfba507192f9b5c330b5984ba71d57d434475f3d62bd44a39201e36fa76304",
           url: url_template % { host_triple: host_triple, arch: arch }
  end
else
  host_triple = "unknown-linux-gnu"

  version "1.32.0" do
    source sha256: "e024698320d76b74daf0e6e71be3681a1e7923122e3ebd03673fcac3ecc23810",
           url: url_template % { host_triple: host_triple, arch: arch }
  end
end

relative_path relative_path_template % { host_triple: host_triple, arch: arch }

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "sh install.sh" \
          " --prefix=#{install_dir}/embedded" \
          " --verbose", env: env
end
