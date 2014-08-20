#
# Copyright 2012-2014 Chef Software, Inc.
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

name "couchdb"
default_version "1.0.3"

dependency "spidermonkey"
dependency "icu"
dependency "curl"
dependency "erlang"

source url: "http://archive.apache.org/dist/couchdb/#{version}/apache-couchdb-#{version}.tar.gz",
       md5: "cfdc2ab751bf18049c5ef7866602d8ed"

relative_path "apache-couchdb-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path).merge(
    "RPATH" => "#{install_dir}/embedded/lib",
    "CURL_CONFIG" => "#{install_dir}/embedded/bin/curl-config",
    "ICU_CONFIG" => "#{install_dir}/embedded/bin/icu-config",
    "ERL" => "#{install_dir}/embedded/bin/erl",
    "ERLC" => "#{install_dir}/embedded/bin/erlc",
  )

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --disable-init" \
          " --disable-launchd" \
          " --with-erlang=#{install_dir}/embedded/lib/erlang/usr/include" \
          " --with-js-include=#{install_dir}/embedded/include" \
           "--with-js-lib=#{install_dir}/embedded/lib", env: env

  make "-j #{max_build_jobs}", env: env
  make "install", env: env
end
