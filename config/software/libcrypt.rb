#
# Copyright:: Chef Software, Inc.
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

name "libxcrypt"
default_version "4.4.38" # Updated for modern .so.2 implementation

license "LGPL-2.1"
license_file "COPYING.LIB"
skip_transitive_dependency_licensing true

version("4.4.38") { source sha256: "e5e1f4cc232668769b96b11a00fbf1597e65bf3694b4e887dfa7ac6b0a90ffd0" } # Verify actual checksum

source url: "https://github.com/besser82/libxcrypt/releases/download/v#{version}/libxcrypt-#{version}.tar.xz"

relative_path "libxcrypt-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  configure_command = [
    "./configure",
    "--prefix=#{install_dir}/embedded",
    "--disable-werror",
    "--enable-hashes=strong,glibc", # Modern hash algorithms
    "--enable-obsolete-api=no",     # Disable legacy .so.1 symbols
    "--disable-static",
    "--with-pic",
  ]

  command configure_command.join(" "), env: env
  make "-j #{workers}", env: env
  make "install", env: env

  # Post-install verification
  command "readelf -d #{install_dir}/embedded/lib/libcrypt.so | grep 'SONAME.*libcrypt.so.2'", env: env
  command "objdump -T #{install_dir}/embedded/lib/libcrypt.so | grep 'GLIBC_2.2.5.*crypt_r'", env: env
end

