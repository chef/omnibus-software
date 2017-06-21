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

# Upgrading postgres requires both the old and the new bin directories to be
# present. To account for that, and not ship a whole lot of stuff for PG 9.2,
# which we want to upgrade _away from_, this software definition only gets us
# oldbindir, e.g. /opt/opscode/embedded/postgresql/9.2/bin.
#
# Having this separate from postgresql-versioned also allows for depending on
# two different versions of one software definition.

name "postgresql-bin-versioned"

pg_common_path = File.expand_path("../../common/postgresql.rb", __FILE__)
instance_eval(IO.read(pg_common_path), pg_common_path)

build do
  env = with_standard_compiler_flags(with_embedded_path)
  short_version = version.gsub(/^([0-9]+).([0-9]+).[0-9]+$/, '\1.\2')

  update_config_guess(target: "config")

  command "./configure" \
          " --prefix=#{install_dir}/embedded/postgresql/#{short_version}" \
          " --with-libedit-preferred" \
          " --with-openssl" \
          " --with-ossp-uuid" \
          " --with-includes=#{install_dir}/embedded/include" \
          " --with-libraries=#{install_dir}/embedded/lib", env: env

  make "world -j #{workers}", env: env
  make "-C src/interfaces/libpq install", env: env # libpq.so
  make "-C src/backend install-bin", env: env      # postgres binary
  make "-C src/bin install", env: env              # pg_*, psql binaries
end
