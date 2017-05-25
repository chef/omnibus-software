#
# Copyright 2014 Chef Software, Inc.
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
default_version "3.1.2"

license "BSD-2-Clause"
license_file "COPYING"
skip_transitive_dependency_licensing true

source url: "http://www.libarchive.org/downloads/libarchive-#{version}.tar.gz",
       md5: "efad5a503f66329bb9d2f4308b5de98a"

relative_path "libarchive-#{version}"

dependency "config_guess"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  update_config_guess(target: "build/autoconf/")

  configure_args = [
    "--prefix=#{install_dir}/embedded",
    "--without-lzma",
    "--without-lzo2",
    "--without-nettle",
    "--without-xml2",
    "--without-expat",
    "--without-bz2lib",
    "--without-iconv",
    "--without-zlib",
    "--disable-bsdtar",
    "--disable-bsdcpio",
    "--without-lzmadec",
    "--without-openssl",
  ]

  if s390x?
    configure_args << "--disable-xattr --disable-acl"
  end

  configure configure_args.join(" "), env: env

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
