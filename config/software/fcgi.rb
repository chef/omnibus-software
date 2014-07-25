#
# Copyright 2012-2014 Chef Software, Inc.omnibus
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

name "fcgi"
default_version "2.4.0"

dependency "autoconf"
dependency "automake"
dependency "libtool"

source url: "http://fastcgi.com/dist/fcgi-2.4.0.tar.gz",
       md5: "d15060a813b91383a9f3c66faf84867e"

relative_path "fcgi-2.4.0"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Patch and touch files so it builds
  diff = <<D
24a25
> #include <cstdio>
D
  command "echo '#{diff}' | patch libfcgi/fcgio.cpp"

  touch "COPYING"
  touch "ChangeLog"
  touch "AUTHORS"
  touch "NEWS"

  # Autoreconf
  command "autoreconf -i -f", env: env
  command "libtoolize", env: env

  # Configure and build
  command "./configure --prefix=#{install_dir}/embedded", env: env

  command "make -j #{max_build_jobs}", env: env
  command "make install"
end
