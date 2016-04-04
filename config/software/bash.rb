#
# Copyright 2015 Chef Software, Inc.
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

name "bash"
default_version "4.3.30"

dependency "libiconv"
dependency "ncurses"

version("4.3.30") { source md5: "a27b3ee9be83bd3ba448c0ff52b28447" }

source url: "https://ftp.gnu.org/gnu/bash/bash-#{version}.tar.gz"

relative_path "bash-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  configure_command = ["./configure",
                       "--prefix=#{install_dir}/embedded"]

  # On freebsd, you have to force static linking, otherwise the executable
  # will link against the system ncurses instead of ours.
  if freebsd?
    configure_command << "--enable-static-link"
  end

  command configure_command.join(" "), env: env
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
