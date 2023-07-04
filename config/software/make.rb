#
# Copyright 2012-2019 Chef Software, Inc.
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

name "make"
default_version "4.3"

license "GPL-3.0"
license_file "COPYING"

# version_list: url=https://ftp.gnu.org/gnu/make/ filter=*.tar.gz

version("4.4") { source sha256: "581f4d4e872da74b3941c874215898a7d35802f03732bdccee1d4a7979105d18" }
version("4.3") { source sha256: "e05fdde47c5f7ca45cb697e973894ff4f5d79e13b750ed57d7b66d8defc78e19" }

source url: "https://ftp.gnu.org/gnu/make/make-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

relative_path "make-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure" \
          " --disable-nls" \
          " --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "install", env: env

  # We are very prescriptive. We made make, we will make all the things use it!
  link "#{install_dir}/embedded/bin/make", "#{install_dir}/embedded/bin/gmake"
end
