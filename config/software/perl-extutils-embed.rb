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
# expeditor/ignore: deprecated 2021-04

name "perl-extutils-embed"
default_version "1.14"

dependency "perl"

source url: "http://search.cpan.org/CPAN/authors/id/D/DO/DOUGM/ExtUtils-Embed-#{version}.tar.gz",
       md5: "b2a2c26a18bca3ce69f8a0b1b54a0105"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
       authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
relative_path "ExtUtils-Embed-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path).merge(
    "INSTALL_BASE" => "#{install_dir}/embedded"
  )

  command "#{install_dir}/embedded/bin/perl Makefile.PL", env: env

  make env: env
  make "install", env: env
end
