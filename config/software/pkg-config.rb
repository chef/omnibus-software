#
# Copyright 2013-2014 Chef Software, Inc.
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

version "0.29" do
  source md5: "77f27dce7ef88d0634d0d6f90e03a77f"
end

version "0.28" do
  source md5: "aa3c86e67551adc3ac865160e34a2a0d"
end

source url: "https://pkgconfig.freedesktop.org/releases/pkg-config-#{version}.tar.gz"

relative_path "pkg-config-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  if version == "0.28" && ppc64le?
    patch source: "v0.28.ppc64le-configure.patch", plevel: 1, env: env
  end

  # pkg-config (at least up to 0.28) includes an older version of
  # libcharset/lib/config.charset that doesn't know about openbsd
  if openbsd?
    patch source: "openbsd-charset.patch", plevel: 1, env: env
  end

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --disable-debug" \
          " --disable-host-tool" \
          " --with-internal-glib" \
          " --with-pc-path=#{install_dir}/embedded/bin/pkgconfig", env: env


  # #203: pkg-configs internal glib does not provide a way to pass ldflags.
  # Only allows GLIB_CFLAGS and GLIB_LIBS.
  # These do not serve our purpose, so we must explicitly
  # ./configure in the glib dir, with the Omnibus ldflags.
  command  "./configure" \
           " --prefix=#{install_dir}/embedded" \
           " --with-libiconv=gnu", env: env, cwd: "#{project_dir}/glib"

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env

  # ensure charset.alias gets installed on openbsd else pkg-config will
  # exit with byte conversion errors.
  if openbsd?
    copy "#{project_dir}/glib/glib/libcharset/charset.alias", "#{install_dir}/embedded/lib/charset.alias"
  end
end
