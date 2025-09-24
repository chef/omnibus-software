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
default_version "3.6.2"

license "BSD-2-Clause"
license_file "COPYING"
skip_transitive_dependency_licensing true

# versions_list: https://github.com/libarchive/libarchive/releases/ filter=*.tar.gz

version("3.8.1") { source sha256: "bde832a5e3344dc723cfe9cc37f8e54bde04565bfe6f136bc1bd31ab352e9fab" }
version("3.7.9") { source sha256: "aa90732c5a6bdda52fda2ad468ac98d75be981c15dde263d7b5cf6af66fd009f" }
version("3.7.5") { source sha256: "37556113fe44d77a7988f1ef88bf86ab68f53d11e85066ffd3c70157cc5110f1" }
version("3.7.4") { source sha256: "7875d49596286055b52439ed42f044bd8ad426aa4cc5aabd96bfe7abb971d5e8" }
version("3.6.2") { source sha256: "ba6d02f15ba04aba9c23fd5f236bb234eab9d5209e95d1c4df85c44d5f19b9b3" }
version("3.6.1") { source sha256: "c676146577d989189940f1959d9e3980d28513d74eedfbc6b7f15ea45fe54ee2" }
version("3.6.0") { source sha256: "a36613695ffa2905fdedc997b6df04a3006ccfd71d747a339b78aa8412c3d852" }
version("3.5.2") { source sha256: "5f245bd5176bc5f67428eb0aa497e09979264a153a074d35416521a5b8e86189" }
version("3.5.1") { source sha256: "9015d109ec00bb9ae1a384b172bf2fc1dff41e2c66e5a9eeddf933af9db37f5a" }
version("3.5.0") { source sha256: "fc4bc301188376adc18780d35602454cc8df6396e1b040fbcbb0d4c0469faf54" }

source url: "https://github.com/libarchive/libarchive/releases/download/v#{version}/libarchive-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

relative_path "libarchive-#{version}"

dependency "config_guess"
dependency "libxml2"
dependency "bzip2"
dependency "zlib"
dependency "liblzma"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env.merge!("LDFLAGS" => "-brtl") if aix?
  #  env.merge!("LDFLAGS" => "-brtl", "LIBS" => "-llzma") if aix?

  update_config_guess(target: "build/autoconf/")

  configure_args = [
    "--prefix=#{install_dir}/embedded",
    "--with-zlib=#{install_dir}/embedded",
    "--with-lzma=#{install_dir}/embedded",
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

  # configure_args << " ; cat config.log" if aix?
  configure_args << "; ls #{install_dir}/embedded" if aix?
  configure_args << "; find #{install_dir}/embedded -name '*lzma*' -print" if aix?
  configure configure_args, env: env

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
