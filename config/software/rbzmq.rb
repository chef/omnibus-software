#
# Copyright 2012-2017 Chef Software, Inc.
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

name "rbzmq"
default_version "master"
source git: "https://github.com/chef/rbzmq.git"

dependency "libzmq"
dependency "libsodium"
dependency "ruby"
dependency "rubygems"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  gem "build rbzmq.gemspec", env: env

  gem_command = [
    "install rbzmq*.gem",
    "--",
    "--use-system-libraries",
    "--with-zmq-dir==#{install_dir}/embedded",
    "--no-doc",
  ]

  gem gem_command.join(" "), env: env
end
