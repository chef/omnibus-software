#
# Copyright 2013-2015 Chef Software, Inc.
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

name "python"
default_version "3.12.0"

license "Python-2.0"
license_file "LICENSE"
skip_transitive_dependency_licensing true

dependency "ncurses"
dependency "zlib"
dependency "openssl"
dependency "bzip2"

if version >= "3.9.0"
  dependency "libffi"
end

# version_list: url=https://www.python.org/ftp/python/#{version}/ filter=*.tgz

version("3.12.0") { source sha256: "51412956d24a1ef7c97f1cb5f70e185c13e3de1f50d131c0aac6338080687afb" }
version("3.11.1") { source sha256: "baed518e26b337d4d8105679caf68c5c32630d702614fc174e98cb95c46bdfa4" }
version("3.11.0") { source sha256: "64424e96e2457abbac899b90f9530985b51eef2905951febd935f0e73414caeb" }
version("3.10.5") { source sha256: "18f57182a2de3b0be76dfc39fdcfd28156bb6dd23e5f08696f7492e9e3d0bf2d" }
version("3.10.4") { source sha256: "f3bcc65b1d5f1dc78675c746c98fcee823c038168fc629c5935b044d0911ad28" }
version("3.10.2") { source sha256: "3c0ede893011319f9b0a56b44953a3d52c7abf9657c23fb4bc9ced93b86e9c97" }
version("3.9.9")  { source sha256: "2cc7b67c1f3f66c571acc42479cdf691d8ed6b47bee12c9b68430413a17a44ea" }
version("2.7.18") { source sha256: "da3080e3b488f648a3d7a4560ddee895284c3380b11d6de75edb986526b9a814" }
version("2.7.14") { source sha256: "304c9b202ea6fbd0a4a8e0ad3733715fbd4749f2204a9173a58ec53c32ea73e8" }
version("2.7.9")  { source sha256: "c8bba33e66ac3201dabdc556f0ea7cfe6ac11946ec32d357c4c6f9b018c12c5b" }

source url: "https://python.org/ftp/python/#{version}/Python-#{version}.tgz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

relative_path "Python-#{version}"
major_version, minor_version = version.split(".")

build do
  env = with_standard_compiler_flags(with_embedded_path)

  if mac_os_x?
    os_x_release = ohai["platform_version"].match(/([0-9]+\.[0-9]+).*/).captures[0]
    env["MACOSX_DEPLOYMENT_TARGET"] = os_x_release
  end

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --enable-shared" \
          " --with-dbmliborder=", env: env

  make env: env
  make "install", env: env

  # There exists no configure flag to tell Python to not compile readline
  delete "#{install_dir}/embedded/lib/python#{major_version}.#{minor_version}/lib-dynload/readline.*"

  # Ditto for sqlite3
  delete "#{install_dir}/embedded/lib/python#{major_version}.#{minor_version}/lib-dynload/_sqlite3.*"
  delete "#{install_dir}/embedded/lib/python#{major_version}.#{minor_version}/sqlite3/"

  # Remove unused extension which is known to make healthchecks fail on CentOS 6
  delete "#{install_dir}/embedded/lib/python#{major_version}.#{minor_version}/lib-dynload/_bsddb.*"

  # Remove sqlite3 libraries, if you want to include sqlite, create a new def
  # in your software project and build it explicitly. This removes the adapter
  # library from python, which links incorrectly to a system library. Adding
  # your own sqlite definition will fix this.
  delete "#{install_dir}/embedded/lib/python#{major_version}.#{minor_version}/lib-dynload/_sqlite3.*"
end
