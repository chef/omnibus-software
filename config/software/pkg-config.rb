#
# Copyright:: Copyright (c) 2014 Chef, Inc.
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

name "pkg-config"
default_version "0.28"

dependency "libiconv"

source :url => 'http://pkgconfig.freedesktop.org/releases/pkg-config-0.28.tar.gz',
  :md5 => 'aa3c86e67551adc3ac865160e34a2a0d'

relative_path 'pkg-config-0.28'

lib_dir = File.join(install_dir, 'embedded/lib')
include_dir = File.join(install_dir, 'embedded/include')

configure_env =
  case Ohai['platform']
  when "aix"
    {
      "CC" => "xlc -q64",
      "CXX" => "xlC -q64",
      "LD" => "ld -b64",
      "CFLAGS" => "-q64 -I#{include_dir} -O",
      "LDFLAGS" => "-q64 -Wl,-blibpath:/usr/lib:/lib",
      "OBJECT_MODE" => "64",
      "ARFLAGS" => "-X64 cru",
      "LD" => "ld -b64",
      "OBJECT_MODE" => "64",
      "ARFLAGS" => "-X64 cru "
    }
  when "mac_os_x"
    {
      "LDFLAGS" => "-L#{lib_dir}",
      "CFLAGS" => "-I#{include_dir}"
    }
  when "solaris2"
    {
      "LDFLAGS" => "-R#{lib_dir} -L#{lib_dir} -static-libgcc",
      "CFLAGS" => "-I#{include_dir}"
    }
  else
    {
      "LDFLAGS" => "-L#{lib_dir}",
      'CFLAGS' => "-I#{include_dir}"
    }
  end

paths = [ "#{install_dir}/embedded/bin/pkgconfig" ]

build do
  command "./configure --prefix=#{install_dir}/embedded --disable-debug --disable-host-tool --with-internal-glib --with-pc-path=#{paths*':'}", :env => configure_env
  # #203: pkg-configs internal glib does not provide a way to pass ldflags.
  # Only allows GLIB_CFLAGS and GLIB_LIBS.
  # These do not serve our purpose, so we must explicitly
  # ./configure in the glib dir, with the Omnibus ldflags.
  command(
    [
      './configure',
      "--prefix=#{install_dir}/embedded",
      '--with-libiconv=gnu'
    ].join(' '),
    env: configure_env,
    cwd: File.join(project_dir, 'glib')
  )
  command "make -j #{max_build_jobs}", :env => configure_env
  command "make -j #{max_build_jobs} install", :env => configure_env
end
