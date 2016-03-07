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

name 'mpfr'
default_version '3.1.2'

dependency 'gmp'

source url: "http://www.mpfr.org/mpfr-#{version}/mpfr-#{version}.tar.gz"

version('3.1.2') { source md5: '181aa7bb0e452c409f2788a4a7f38476' }
version('3.1.3') { source md5: '7b650781f0a7c4a62e9bc8bdaaa0018b' }

relative_path "mpfr-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  configure_command = ['./configure',
                       "--prefix=#{install_dir}/embedded"]

  command configure_command.join(' '), env: env
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
