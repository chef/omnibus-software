#
# Copyright 2014-2021 Chef Software, Inc.
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

# A requirement for api.berkshelf.com that is used in berkshelf specs
# https://github.com/berkshelf/api.berkshelf.com

name "libarchive"
default_version "3.5.2"

license "BSD-2-Clause"
license_file "COPYING"
skip_transitive_dependency_licensing true

# versions_list: https://github.com/libarchive/libarchive/releases/ filter=*.tar.gz
version("3.5.2") { source sha256: "5f245bd5176bc5f67428eb0aa497e09979264a153a074d35416521a5b8e86189" }
version("3.5.1") { source sha256: "9015d109ec00bb9ae1a384b172bf2fc1dff41e2c66e5a9eeddf933af9db37f5a" }
version("3.5.0") { source sha256: "fc4bc301188376adc18780d35602454cc8df6396e1b040fbcbb0d4c0469faf54" }

# 3.5.1 did not include the "v" in the path
if version.satisfies?("= 3.5.1")
  source url: "https://github.com/libarchive/libarchive/releases/download/#{version}/libarchive-#{version}.tar.gz"
else
  source url: "https://github.com/libarchive/libarchive/releases/download/v#{version}/libarchive-#{version}.tar.gz"
end

relative_path "libarchive-#{version}"

dependency "config_guess"
dependency "libxml2"
dependency "bzip2"
dependency "zlib"
dependency "liblzma"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  update_config_guess(target: "build/autoconf/")

  configure_args = [
    "--prefix=#{install_dir}/embedded",
    "--without-lzo2",
    "--without-nettle",
    "--without-expat",
    "--without-iconv",
    "--disable-bsdtar", # tar command line tool
    "--disable-bsdcpio", # cpio command line tool
    "--disable-bsdcat", # cat w/ decompression command line tool
    "--without-openssl",
    "--without-zstd",
    "--without-lz4",
  ]

  if s390x?
    configure_args << "--disable-xattr --disable-acl"
  end

  configure configure_args.join(" "), env: env

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
