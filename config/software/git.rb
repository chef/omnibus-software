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

name "git"
default_version "1.9.5"

dependency "curl"
dependency "zlib"
dependency "openssl"
dependency "pcre"
dependency "libiconv"
dependency "expat"
dependency "perl"

relative_path "git-#{version}"

source url: "https://github.com/git/git/archive/v#{version}.tar.gz",
       md5: "a50979e98068f7dae8ad34492d0ef5a8"

build do
  env = with_standard_compiler_flags(with_embedded_path).merge(
    "NO_GETTEXT"         => "1",
    "NO_PYTHON"          => "1",
    "NO_TCLTK"           => "1",
    "NO_R_TO_GCC_LINKER" => "1",
    "NEEDS_LIBICONV"     => "1",

    "PERL_PATH"  => "#{install_dir}/embedded/bin/perl",
    "ZLIB_PATH"  => "#{install_dir}/embedded",
    "ICONVDIR"   => "#{install_dir}/embedded",
    "OPENSSLDIR" => "#{install_dir}/embedded",
    "EXPATDIR"   => "#{install_dir}/embedded",
    "CURLDIR"    => "#{install_dir}/embedded",
    "LIBPCREDIR" => "#{install_dir}/embedded",
  )

  make "-j #{workers} prefix=#{install_dir}/embedded", env: env
  make "install prefix=#{install_dir}/embedded", env: env
end
