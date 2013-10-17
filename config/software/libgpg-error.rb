#
# Copyright:: Copyright (c) 2013 Robby Dyer
# License:: Apache License, Version 2.0
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
name "libgpg-error"
version "1.12"

source :url => "ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-#{version}.tar.bz2",
       :md5 => "8f0eb41a344d19ac2aa9bd101dfb9ce6"

relative_path "libgpg-error-#{version}"

build do
  command "./configure --prefix=#{install_dir}/embedded"
  command "make"
  command "make install"
end
