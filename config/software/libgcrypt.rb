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
name "libgcrypt"
version "1.5.2"

dependency "libgpg-error"

source :url => "ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-#{version}.tar.bz2",
       :md5 => "668aa1a1aae93f5fccb7eda4be403026"

relative_path "libgcrypt-#{version}"

build do
  command "./configure --prefix=#{install_dir}/embedded --with-gpg-error-prefix=#{install_dir}/embedded"
  command "make"
  command "make install"
end
