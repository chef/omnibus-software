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
default_version "2.9.13"

license "MIT"
license_file "COPYING"
skip_transitive_dependency_licensing true

dependency "zlib"
dependency "liblzma"
dependency "config_guess"

# version_list: url=https://download.gnome.org/sources/libxml2/2.9/ filter=*.tar.xz
version("2.9.13") do
  if windows?
    source url: "https://github.com/kiyolee/libxml2-win-build/archive/refs/tags/v2.9.13.tar.gz",
           sha256: "fc4d1259584530d25521f2dd4c5a0da79bb612cc821bf637accc97c18fd1c537",
    relative_path "libxml2-win-build-#{version}"
  end
  source url: "https://download.gnome.org/sources/libxml2/2.9/libxml2-2.9.13.tar.xz",
         sha256: "276130602d12fe484ecc03447ee5e759d0465558fbc9d6bd144e3745306ebf0e",
  relative_path "libxml2-#{version}"
end
version("2.9.12") do
  source url: "https://download.gnome.org/sources/libxml2/2.9/libxml2-#{version}.tar.xz",
         sha256: "28a92f6ab1f311acf5e478564c49088ef0ac77090d9c719bbc5d518f1fe62eb9",
  relative_path "libxml2-#{version}"
end
version("2.9.10") do
  source sha256: "593b7b751dd18c2d6abcd0c4bcb29efc203d0b4373a6df98e3a455ea74ae2813",
  source url: "https://download.gnome.org/sources/libxml2/2.9/libxml2-#{version}.tar.xz",
  relative_path "libxml2-#{version}"
end
version("2.9.9")  do
  source sha256: "58a5c05a2951f8b47656b676ce1017921a29f6b1419c45e3baed0d6435ba03f5",
  source url: "https://download.gnome.org/sources/libxml2/2.9/libxml2-#{version}.tar.xz",
  relative_path "libxml2-#{version}"
end


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
