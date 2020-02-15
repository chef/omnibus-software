#
# Copyright 2014-2020 Chef Software, Inc.
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
default_version "3.4.2"

license "BSD-2-Clause"
license_file "COPYING"
skip_transitive_dependency_licensing true

version("3.4.2") { source sha256: "b60d58d12632ecf1e8fad7316dc82c6b9738a35625746b47ecdcaf4aed176176" }
version("3.4.1") { source sha256: "fcf87f3ad8db2e4f74f32526dee62dd1fb9894782b0a503a89c9d7a70a235191" }
version("3.4.0") { source sha256: "8643d50ed40c759f5412a3af4e353cffbce4fdf3b5cf321cb72cacf06b2d825e" }
version("3.3.3") { source sha256: "ba7eb1781c9fbbae178c4c6bad1c6eb08edab9a1496c64833d1715d022b30e2e" }
version("3.3.2") { source sha256: "ed2dbd6954792b2c054ccf8ec4b330a54b85904a80cef477a1c74643ddafa0ce" }
version("3.1.2") { source sha256: "eb87eacd8fe49e8d90c8fdc189813023ccc319c5e752b01fb6ad0cc7b2c53d5e" }

source url: "http://www.libarchive.org/downloads/libarchive-#{version}.tar.gz"

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
    "--without-openssl",
    "--without-zstd",
  ]

  if s390x?
    configure_args << "--disable-xattr --disable-acl"
  end

  configure configure_args.join(" "), env: env

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
