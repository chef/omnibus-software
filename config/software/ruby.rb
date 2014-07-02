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

name "ruby"
default_version "1.9.3-p545"

dependency "zlib"
dependency "ncurses"
dependency "libedit"
dependency "openssl"
dependency "libyaml"
dependency "libiconv"
dependency "libffi"
dependency "gdbm"
dependency "libgcc" if platform == "solaris2"

version "1.9.3-p545" do
  source md5: '8e8f6e4d7d0bb54e0edf8d9c4120f40c'
end

version "2.1.1" do
  source md5: 'e57fdbb8ed56e70c43f39c79da1654b2'
end

source url: "http://cache.ruby-lang.org/pub/ruby/#{version.match(/^(\d+\.\d+)/)[0]}/ruby-#{version}.tar.gz"

relative_path "ruby-#{version}"

env = with_embedded_path()
env = with_standard_compiler_flags(env)

case platform
when "mac_os_x"
  # -Qunused-arguments suppresses "argument unused during compilation"
  # warnings. These can be produced if you compile a program that doesn't
  # link to anything in a path given with -Lextra-libs. Normally these
  # would be harmless, except that autoconf treats any output to stderr as
  # a failure when it makes a test program to check your CFLAGS (regardless
  # of the actual exit code from the compiler).
  env['CFLAGS'] << " -I#{install_dir}/embedded/include/ncurses -arch x86_64 -m64 -O3 -g -pipe -Qunused-arguments"
  env['LDFLAGS'] << " -arch x86_64"
when "aix"
  # -O2/O3 optimized away some configure test which caused ext libs to fail, so aix only gets -O
  #
  # We also need prezl's M4 instead of picking up /usr/bin/m4 which
  # barfs on ruby.
  #
  # I believe -qhot was necessary to prevent segfaults in threaded libs
  #
  env['CFLAGS'] << " -q64 -qhot"
  env['M4'] = "/opt/freeware/bin/m4"
  env['warnflags'] = "-qinfo=por"
else  # including solaris, linux
  env['CFLAGS'] << " -O3 -g -pipe"
end

build do
  configure_command = ["./configure",
                       "--prefix=#{install_dir}/embedded",
                       "--with-out-ext=dbm",
                       "--enable-shared",
                       "--enable-libedit",
                       "--with-ext=psych",
                       "--disable-install-doc",
                       "--without-gmp"]

  case platform
  when "aix"
    patch :source => "ruby-aix-configure.patch", :plevel => 1
    patch :source => "ruby_aix_1_9_3_448_ssl_EAGAIN.patch", :plevel => 1
    # --with-opt-dir causes ruby to send bogus commands to the AIX linker
  when "freebsd"
    configure_command << "--without-execinfo"
    configure_command << "--with-opt-dir=#{install_dir}/embedded"
  when "smartos"
    # Opscode patch - someara@opscode.com
    # GCC 4.7.0 chokes on mismatched function types between OpenSSL 1.0.1c and Ruby 1.9.3-p286
    patch :source => "ruby-openssl-1.0.1c.patch", :plevel => 1

    # Patches taken from RVM.
    # http://bugs.ruby-lang.org/issues/5384
    # https://www.illumos.org/issues/1587
    # https://github.com/wayneeseguin/rvm/issues/719
    patch :source => "rvm-cflags.patch", :plevel => 1

    # From RVM forum
    # https://github.com/wayneeseguin/rvm/commit/86766534fcc26f4582f23842a4d3789707ce6b96
    configure_command << "ac_cv_func_dl_iterate_phdr=no"
    configure_command << "--with-opt-dir=#{install_dir}/embedded"
  else
    configure_command << "--with-opt-dir=#{install_dir}/embedded"
  end

  # @todo expose bundle_bust() in the DSL
  env.merge!({
    "RUBYOPT"         => nil,
    "BUNDLE_BIN_PATH" => nil,
    "BUNDLE_GEMFILE"  => nil,
    "GEM_PATH"        => nil,
    "GEM_HOME"        => nil
  })

  # @todo: move into omnibus-ruby
  has_gmake = system("gmake --version")

  if has_gmake
    env.merge!({'MAKE' => 'gmake'})
    make_binary = 'gmake'
  else
    make_binary = 'make'
  end

  command configure_command.join(" "), :env => env
  command "#{make_binary} -j #{max_build_jobs}", :env => env
  command "#{make_binary} -j #{max_build_jobs} install", :env => env
end
