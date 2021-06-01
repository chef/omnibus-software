#
# Copyright 2016 Chef Software, Inc.
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

name "stunnel"
default_version "5.59"

license "GPL-2.0"
license_file "COPYING"
skip_transitive_dependency_licensing true

dependency "openssl"

source url:
"https://www.stunnel.org/downloads/stunnel-#{version}.tar.gz"
relative_path "stunnel-#{version}"

version("5.59") { source sha256: "137776df6be8f1701f1cd590b7779932e123479fb91e5192171c16798815ce9f" }  
version("5.39") { source sha256: "288c087a50465390d05508068ac76c8418a21fae7275febcc63f041ec5b04dee" }
version("5.38") { source sha256: "09ada29ba1683ab1fd1f31d7bed8305127a0876537e836a40cb83851da034fd5" }

build do
  env = with_standard_compiler_flags(with_embedded_path)

  patch source: "stunnel-on-windows.patch", plevel: 1, env: env if windows?

  configure_args = [
    "--with-ssl=#{install_dir}/embedded",
    "--prefix=#{install_dir}/embedded",
  ]
  configure_args << "--enable-fips" if fips_mode?

  configure(*configure_args, env: env)

  if windows?
    # src/mingw.mk hardcodes and assumes SSL is at /opt so we patch and use
    # an env variable to redirect it to the correct location
    env["WIN32_SSL_DIR_PATCHED"] = "#{install_dir}/embedded"

    mingw = ENV["MSYSTEM"].downcase
    target = (mingw == "mingw32" ? "mingw" : mingw)
    # Starting omnibus-toolchain version 1.1.115 we do not build msys2 as a part of omnibus-toolchain anymore, but pre install it in image
    # so here we set the path to default install of msys2 first and default to OMNIBUS_TOOLCHAIN_INSTALL_DIR for backward compatibility
    msys_path = ENV["MSYS2_INSTALL_DIR"] ? "#{ENV["MSYS2_INSTALL_DIR"]}" : "#{ENV["OMNIBUS_TOOLCHAIN_INSTALL_DIR"]}/embedded/bin"

    make target, env: env, cwd: "#{project_dir}/src"

    block "copy required windows files" do
      copy_files = [
        "#{project_dir}/bin/#{target}/stunnel.exe",
        "#{project_dir}/bin/#{target}/tstunnel.exe",
        "#{msys_path}/#{mingw}/bin/libssp-0.dll",
      ]
      copy_files.each do |file|
        if File.exist?(file)
          copy file, "#{install_dir}/embedded/bin/#{File.basename(file)}"
        else
          raise "Cannot find required file for Windows: #{file}"
        end
      end
    end
  else
    make env: env
    make "install", env: env
  end
end
