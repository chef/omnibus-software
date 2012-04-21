#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
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

name "readline"
version "6.2"

# NOTE: the clojure omnibus uses readline 5.2, which is super old.
# there might be a reason for that, and if this doesn't build on other
# platforms then we might need to go back to using the old version
source :url => 'http://ftp.gnu.org/gnu/readline/readline-6.2.tar.gz',
       :md5 => '67948acb2ca081f23359d0256e9a271c'

relative_path "readline-6.2"

configure_env =
  case platform
  when "darwin"
    {
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
    }
  when "freebsd"
    {
      "CFLAGS" => "-fPIC -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
    }
  when "solaris2"
    {
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
    }
  else
    {
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-Wl,-rpath #{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
    }
  end

build do
  command "./configure --prefix=#{install_dir}/embedded", :env => configure_env
  command "make"
  command "make install"
end
