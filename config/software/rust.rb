#
# Copyright 2016 Chef Software, Inc.
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
default_version "1.27.0"

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

    version "1.27.0" do
      source sha256: "8aff736c3c456e4b8c5ade02ae9b725eb9e896c303c8c160c7b414dab3b69681",
             url: url_template % { host_triple: host_triple, arch: arch }
    end

    version "1.26.1" do
      source sha256: "de7cd78c9f5b0ccbac5fd3d30796a643d671e3ddccbb65e22b61a62f94dab1a8",
             url: url_template % { host_triple: host_triple, arch: arch }
    end

    version "1.15.0" do
      source sha256: "eb13db88611bb53a8a3b5ed905f646ff77070ff68b49de55907db1e000352c7b",
             url: url_template % { host_triple: host_triple, arch: arch }
    end

    version "1.13.0" do
      source sha256: "ad7d809ca8330429be5e12a87e51adcef636e84323b183170cb5fd6465292301",
             url: url_template % { host_triple: host_triple, arch: arch }
    end

    version "1.12.0" do
      source sha256: "15f5e3d41984afc14be7858d88ee9de0945352ab0df6e2954a1a872dad4ed343",
             url: url_template % { host_triple: host_triple, arch: arch }
    end

    version "1.9.0" do
      source sha256: "df2dfd8a455769c183f764b109786fb96ecd6af2a10912e86342d9d4df16ea82",
             url: url_template % { host_triple: host_triple, arch: arch }
    end

    version "1.8.0" do
      source sha256: "5cc8049edcd2d350d621227fdc52b19bf9668bcad4a39868dabbcc69a9a50aef",
             url: url_template % { host_triple: host_triple, arch: arch }
    end

    version "2015-10-03" do
      source md5: "e56f92d70db368027f01c4d9fe69ec9f",
             url: url_template % { host_triple: host_triple, arch: arch }
    end
  else
    version "1.27.0" do
      source sha256: "c8b26cd85d890794c13c4494d47d9dbd2e9f8a2d3dbc7601819d6fc21bd24484",
             url: url_template % { host_triple: host_triple, arch: arch }
    end

    version "1.26.1" do
      source sha256: "35693cab9c254e04d3085f7f4566c353e70e23cd1be83c1ff6a32efc1b69769c",
             url: url_template % { host_triple: host_triple, arch: arch }
    end

    version "1.15.0" do
      source sha256: "dd102a47edd39af6e3acd1f35f3e41d185f2661bc9c28462ae70cab0bfd42306",
             url: url_template % { host_triple: host_triple, arch: arch }
    end

    version "1.13.0" do
      source sha256: "f3df5d1f376e232eea47da52a57422994d8a82291f5bfbf170b46919792b2240",
             url: url_template % { host_triple: host_triple, arch: arch }
    end

    version "1.12.0" do
      source sha256: "66bf7cd73400f1046a971870735f5aad17d1b12a3b93f7c6d8fdb4b381d31365",
             url: url_template % { host_triple: host_triple, arch: arch }
    end

    version "1.9.0" do
      source sha256: "0b052f2c7541dd10ad7ea61402a6a4381acbac4bb43feef6bd8ee89c5d815412",
             url: url_template % { host_triple: host_triple, arch: arch }
    end

    version "1.8.0" do
      source sha256: "f07fbab9b9ab87c3337fbf9bb078420b4a9ba769b2f03009db9732a081d0f436",
             url: url_template % { host_triple: host_triple, arch: arch }
    end

    version "2015-10-03" do
      source md5: "25ae6f2624a02fde12d515779a238658",
             url: url_template % { host_triple: host_triple, arch: arch }
    end
  end

elsif mac_os_x?
  host_triple = "apple-darwin"

  version "1.27.0" do
    source sha256: "a1d48190992e01aac1a181bce490c80cb2c1421724b4ff0e2fb7e224a958ce0f",
           url: url_template % { host_triple: host_triple, arch: arch }
  end

  version "1.26.1" do
    source sha256: "ebf898b9fa7e2aafc53682a41f18af5ca6660ebe82dd78f28cd9799fe4dc189a",
           url: url_template % { host_triple: host_triple, arch: arch }
  end

  version "1.15.0" do
    source sha256: "8b02c3714d30a6111af805d76df0de28c045f883a9171839ebd5667327f2e50a",
           url: url_template % { host_triple: host_triple, arch: arch }
  end

  version "1.13.0" do
    source sha256: "f538ca5732b844cf7f00fc4aaaf200a49a845b58b4ec8aef38da0b00e2cf6efe",
           url: url_template % { host_triple: host_triple, arch: arch }
  end

  version "1.12.0" do
    source sha256: "608c4530dcbd2e29c9600a0743b1a83a62556c9525385a7e1a7ba4aa1467a132",
           url: url_template % { host_triple: host_triple, arch: arch }
  end

  version "1.9.0" do
    source sha256: "d59b5509e69c1cace20a57072e3b3ecefdbfd8c7e95657b0ff2ac10aa1dfebe6",
           url: url_template % { host_triple: host_triple, arch: arch }
  end

  version "1.8.0" do
    source sha256: "606bfa2ac277f2f37be1bbd4fd933f7820c8ed7b39efe8f58c1063e9a31d326e",
           url: url_template % { host_triple: host_triple, arch: arch }
  end

  version "2015-10-03" do
    source md5: "0485cb9902a3b3c563c6c6e20b311419",
           url: url_template % { host_triple: host_triple, arch: arch }
  end
else
  host_triple = "unknown-linux-gnu"

  version "1.27.0" do
    source sha256: "235ad78e220b10a2d0267aea1e2c0f19ef5eaaff53ad6ff8b12c1d4370dec9a3",
           url: url_template % { host_triple: host_triple, arch: arch }
  end

  version "1.26.1" do
    source sha256: "b7e964bace1286696d511c287b945f3ece476ba77a231f0c31f1867dfa5080e0",
           url: url_template % { host_triple: host_triple, arch: arch }
  end

  version "1.15.0" do
    source sha256: "576fcced49744af5ea438afc4411395530426b0a3d4839c5205f646f15850663",
           url: url_template % { host_triple: host_triple, arch: arch }
  end

  version "1.13.0" do
    source sha256: "95f4c372b1b81ac1038161e87e932dd7ab875d25c167a861c3949b0f6a65516d",
           url: url_template % { host_triple: host_triple, arch: arch }
  end

  version "1.12.0" do
    source sha256: "3a9647123f1f056571d6603e40f21a96162702e1ae4725ee8c2bc9452a87cf5d",
           url: url_template % { host_triple: host_triple, arch: arch }
  end

  version "1.9.0" do
    source sha256: "288ff13efa2577e81c77fc2cb6e2b49b1ed0ceab51b4fa12f7efb87039ac49b7",
           url: url_template % { host_triple: host_triple, arch: arch }
  end

  version "1.8.0" do
    source sha256: "d5a7c10070f8053defe07d1704762c91e94fc30a1020d16b111d63e9af365d48",
           url: url_template % { host_triple: host_triple, arch: arch }
  end

  version "2015-10-03" do
    source md5: "eff35d920b30f191b659075a563197a6",
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
