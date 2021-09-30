#
# Copyright 2014-2018 Chef Software, Inc.
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

name "dep-selector-libgecode"
default_version "1.3.1"

license "Apache-2.0"
license_file "https://raw.githubusercontent.com/chef/dep-selector-libgecode/master/LICENSE"
# dep-selector-libgecode does not have any dependencies. We only install it from
# rubygems here.
skip_transitive_dependency_licensing true

dependency "ruby"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # On some RHEL-based systems, the default GCC that's installed is 4.1. We
  # need to use 4.4, which is provided by the gcc44 and gcc44-c++ packages.
  # These do not use the gcc binaries so we set the flags to point to the
  # correct version here.
  if File.exist?("/usr/bin/gcc44")
    env["CC"]  = "gcc44"
    env["CXX"] = "g++44"
  end

  # Ruby DevKit ships with BSD Tar
  env["PROG_TAR"] = "bsdtar" if windows?
  env["ARFLAGS"] = "rv #{env["ARFLAGS"]}" if env["ARFLAGS"]

  gem "install dep-selector-libgecode" \
      " --version '#{version}'" \
      "  --no-document", env: env
end
