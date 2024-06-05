#
# Copyright:: Chef Software Inc.
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

name "libxml2"
default_version "2.11.7"

license "MIT"
license_file "COPYING"
skip_transitive_dependency_licensing true

dependency "zlib"
dependency "liblzma"
dependency "config_guess"

# version_list: url=https://download.gnome.org/sources/libxml2/ filter=*.tar.xz
version("2.12.5") { source sha256: "a972796696afd38073e0f59c283c3a2f5a560b5268b4babc391b286166526b21" }
version("2.11.7") { source sha256: "fb27720e25eaf457f94fd3d7189bcf2626c6dccf4201553bc8874d50e3560162" }
version("2.10.4") { source sha256: "ed0c91c5845008f1936739e4eee2035531c1c94742c6541f44ee66d885948d45" }
version("2.9.14") { source sha256: "60d74a257d1ccec0475e749cba2f21559e48139efba6ff28224357c7c798dfee" }
version("2.9.13") { source sha256: "276130602d12fe484ecc03447ee5e759d0465558fbc9d6bd144e3745306ebf0e" }
version("2.9.12") { source sha256: "28a92f6ab1f311acf5e478564c49088ef0ac77090d9c719bbc5d518f1fe62eb9" }
version("2.9.10") { source sha256: "593b7b751dd18c2d6abcd0c4bcb29efc203d0b4373a6df98e3a455ea74ae2813" }
version("2.9.9")  { source sha256: "58a5c05a2951f8b47656b676ce1017921a29f6b1419c45e3baed0d6435ba03f5" }

minor_version = version.gsub(/\.\d+\z/, "")
source url: "https://download.gnome.org/sources/libxml2/#{minor_version}/libxml2-#{version}.tar.xz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.xz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

relative_path "libxml2-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  configure_command = [
    "--with-zlib=#{install_dir}/embedded",
    "--with-lzma=#{install_dir}/embedded",
    "--with-sax1", # required for nokogiri to compile
    "--without-iconv",
    "--without-python",
    "--without-icu",
    "--without-debug",
    "--without-mem-debug",
    "--without-run-debug",
    "--without-legacy", # we don't need legacy interfaces
    "--without-catalog",
    "--without-docbook",
  ]

  update_config_guess

  configure(*configure_command, env: env)

  make "-j #{workers}", env: env
  make "install", env: env
end
