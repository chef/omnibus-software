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

name "libffi"
default_version "3.0.13"

dependency "libtool"

source url: "ftp://sourceware.org/pub/libffi/libffi-3.0.13.tar.gz",
       md5: '45f3b6dbc9ee7c7dfbbbc5feba571529'

relative_path "libffi-3.0.13"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure" \
          " --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env

  # On 64-bit distro libffi libraries may be placed under /embedded/lib64
  # move them over to lib
  block do
    if File.directory?("#{dest_dir}/#{install_dir}/embedded/lib64")
      # Can't use 'move' here since that uses FileUtils.mv, which on < Ruby 2.2.0-dev
      # returns ENOENT on moving symlinks with broken (in this case, already moved) targets.
      # http://comments.gmane.org/gmane.comp.lang.ruby.cvs/49907
      copy "#{dest_dir}/#{install_dir}/embedded/lib64/*", "#{dest_dir}/#{install_dir}/embedded/lib/"
      delete "#{dest_dir}/#{install_dir}/embedded/lib64"
    end

    # libffi's default install location of header files is awful...
    copy "#{dest_dir}/#{install_dir}/embedded/lib/libffi-#{version}/include/*", "#{dest_dir}/#{install_dir}/embedded/include"
  end

end

