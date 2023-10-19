#
# Copyright:: Copyright (c) 2012-2014 Chef Software, Inc.
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

name "postgresql"
default_version "10.19" # 10.19 is the oldest version with OpenSSL 3 support

dependency "zlib"
dependency ENV["OMNIBUS_OPENSSL_SOFTWARE"] || "openssl"

version "10.19" do
  source sha256: "6eb830b428b60e84ae87e20436bce679c4d9d0202be7aec0e41b0c67d9134239"
end

version "9.1.9" do
  source sha256: "28a533e181009308722e8b3c51f1ea7224ab910c380ac1a86f07118667602dd8"
end

version "9.2.8" do
  source sha256: "568ba482340219097475cce9ab744766889692ee7c9df886563e8292d66ed87c"
end

version "9.3.4" do
  source sha256: "9ee819574dfc8798a448dc23a99510d2d8924c2f8b49f8228cd77e4efc8a6621"
end

# Version lower than 9.4 aren't compatible with openssl 1.1
# (9.4.12 for openssl 1.1.0 and 9.4.24 for visual studio)
version "9.4.25" do
  source sha256: "cb98afaef4748de76c13202c14198e3e4717adde49fd9c90fdc81da877520928"
end

source url: "https://ftp.postgresql.org/pub/source/v#{version}/postgresql-#{version}.tar.bz2"
relative_path "postgresql-#{version}"

configure_env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
}

build do
  command ["./configure",
           "--prefix=#{install_dir}/embedded",
           "--without-readline",
           "--with-openssl --with-includes=#{install_dir}/embedded/include",
           "--with-libraries=#{install_dir}/embedded/lib"].join(" "), env: configure_env
  command "make -j #{workers}", env: { "LD_RUN_PATH" => "#{install_dir}/embedded/lib" }
  command "make install"

  delete "#{install_dir}/embedded/lib/postgresql/pgxs/src/test/"

  delete "#{install_dir}/embedded/lib/libecpg.a"
  delete "#{install_dir}/embedded/lib/libecpg_compat.a"
  delete "#{install_dir}/embedded/lib/libltdl.a"
  delete "#{install_dir}/embedded/lib/liblua.a"
  delete "#{install_dir}/embedded/lib/libpgcommon.a"
  delete "#{install_dir}/embedded/lib/libpgfeutils.a"
  delete "#{install_dir}/embedded/lib/libpgport.a"
  delete "#{install_dir}/embedded/lib/libpgtypes.a"
  delete "#{install_dir}/embedded/lib/libpq.a"

  # Delete postgres' binaries, except for pg_config which is required by psycopg's build
  delete "#{install_dir}/embedded/bin/clusterdb"
  delete "#{install_dir}/embedded/bin/createdb"
  delete "#{install_dir}/embedded/bin/createuser"
  delete "#{install_dir}/embedded/bin/dropdb"
  delete "#{install_dir}/embedded/bin/dropuser"
  delete "#{install_dir}/embedded/bin/ecpg"
  delete "#{install_dir}/embedded/bin/initdb"
  delete "#{install_dir}/embedded/bin/pg_archivecleanup"
  delete "#{install_dir}/embedded/bin/pg_basebackup"
  delete "#{install_dir}/embedded/bin/pg_controldata"
  delete "#{install_dir}/embedded/bin/pg_ctl"
  delete "#{install_dir}/embedded/bin/pg_dump"
  delete "#{install_dir}/embedded/bin/pg_dumpall"
  delete "#{install_dir}/embedded/bin/pg_isready"
  delete "#{install_dir}/embedded/bin/pg_receivewal"
  delete "#{install_dir}/embedded/bin/pg_recvlogical"
  delete "#{install_dir}/embedded/bin/pg_resetwal"
  delete "#{install_dir}/embedded/bin/pg_restore"
  delete "#{install_dir}/embedded/bin/pg_rewind"
  delete "#{install_dir}/embedded/bin/pg_test_fsync"
  delete "#{install_dir}/embedded/bin/pg_test_timing"
  delete "#{install_dir}/embedded/bin/pg_upgrade"
  delete "#{install_dir}/embedded/bin/pg_waldump"
  delete "#{install_dir}/embedded/bin/pgbench"
  delete "#{install_dir}/embedded/bin/postgres"
  delete "#{install_dir}/embedded/bin/postmaster"
  delete "#{install_dir}/embedded/bin/psql"
  delete "#{install_dir}/embedded/bin/reindexdb"
  delete "#{install_dir}/embedded/bin/vacuumdb"
end
