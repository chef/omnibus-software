#
# Copyright 2023 Chef Software, Inc.
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

name "openssl3"

license "Apache-2.0"
license_file "LICENSE.txt"
skip_transitive_dependency_licensing true

dependency "zlib"
dependency "cacerts"
dependency "makedepend" unless windows?

default_version "3.0.11"

source url: "https://www.openssl.org/source/openssl-#{version}.tar.gz", extract: :lax_tar

version("3.1.0") { source sha256: "aaa925ad9828745c4cad9d9efeb273deca820f2cdcf2c3ac7d7c1212b7c497b4" }
version("3.0.9") { source sha256: "eb1ab04781474360f77c318ab89d8c5a03abc38e63d65a603cabbf1b00a1dc90" }
version("3.0.8") { source sha256: "6c13d2bf38fdf31eac3ce2a347073673f5d63263398f1f69d0df4a41253e4b3e" }
version("3.0.11") { source sha256: "b3425d3bb4a2218d0697eb41f7fc0cdede016ed19ca49d168b78e8d947887f55" }

relative_path "openssl-#{version}"

build do

  env = with_standard_compiler_flags(with_embedded_path)
  if windows?
    # XXX: OpenSSL explicitly sets -march=i486 and expects that to be honored.
    # It has OPENSSL_IA32_SSE2 controlling whether it emits optimized SSE2 code
    # and the 32-bit calling convention involving XMM registers is...  vague.
    # Do not enable SSE2 generally because the hand optimized assembly will
    # overwrite registers that mingw expects to get preserved.
    env["CFLAGS"] = "-I#{install_dir}/embedded/include"
    env["CPPFLAGS"] = env["CFLAGS"]
    env["CXXFLAGS"] = env["CFLAGS"]
  end

  configure_args = [
    "--prefix=#{install_dir}/embedded",
    "--with-zlib-lib=#{install_dir}/embedded/lib",
    "--with-zlib-include=#{install_dir}/embedded/include",
    "--libdir=lib",
    "no-idea",
    "no-mdc2",
    "no-rc5",
    "shared",
    "no-ssl3",
    "no-gost",
  ]

  if windows?
    configure_args << "zlib-dynamic"
  else
    configure_args << "zlib"
  end

  configure_cmd =
    if mac_os_x?
      "./Configure darwin64-x86_64-cc"
    elsif windows?
      platform = windows_arch_i386? ? "mingw" : "mingw64"
      "perl.exe ./Configure #{platform}"
    else
      "./config"
    end

  # Out of abundance of caution, we put the feature flags first and then
  # the crazy platform specific compiler flags at the end.
  configure_args << env["CFLAGS"] << env["LDFLAGS"]

  configure_command = configure_args.unshift(configure_cmd).join(" ")

  command configure_command, env: env, in_msys_bash: true

  patch source: "openssl-3.0.9-do-not-build-docs.patch", env: env

  command "make depend", env: env
  command "make -j #{workers}", env: env
  command "make install", env: env

  unless windows?
    # Remove openssl static libraries here as we can't disable those at build time
    delete "#{install_dir}/embedded/lib/libcrypto.a"
    delete "#{install_dir}/embedded/lib/libssl.a"
  end
end
