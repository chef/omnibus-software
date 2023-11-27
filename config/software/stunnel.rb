#
# Copyright:: Chef Software, Inc.
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
default_version "5.49"
# Pin stunnel to 5.49 as it's the last version that supports FIPS with standard builds.

license "GPL-2.0"
license_file "COPYING"
skip_transitive_dependency_licensing true

dependency "openssl"

# version_list: url=https://www.stunnel.org/downloads/ filter=*.tar.gz

source url: "https://www.stunnel.org/archive/5.x/stunnel-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
           authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

relative_path "stunnel-#{version}"

version("5.71") { source sha256: "f023aae837c2d32deb920831a5ee1081e11c78a5d57340f8e6f0829f031017f5" }
version("5.67") { source sha256: "3086939ee6407516c59b0ba3fbf555338f9d52f459bcab6337c0f00e91ea8456" }
version("5.66") { source sha256: "558178704d1aa5f6883aac6cc5d6bbf2a5714c8a0d2e91da0392468cee9f579c" }
version("5.65") { source sha256: "60c500063bd1feff2877f5726e38278c086f96c178f03f09d264a2012d6bf7fc" }
version("5.64") { source sha256: "eebe53ed116ba43b2e786762b0c2b91511e7b74857ad4765824e7199e6faf883" }
version("5.63") { source sha256: "c74c4e15144a3ae34b8b890bb31c909207301490bd1e51bfaaa5ffeb0a994617" }
version("5.59") { source sha256: "137776df6be8f1701f1cd590b7779932e123479fb91e5192171c16798815ce9f" }
version("5.49") { source sha256: "3d6641213a82175c19f23fde1c3d1c841738385289eb7ca1554f4a58b96d955e" }
version("5.39") { source sha256: "288c087a50465390d05508068ac76c8418a21fae7275febcc63f041ec5b04dee" }

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Across different versions the files have been changed and a single patch cannot be applied successfully
  # We have two different patches:
  #  * stunnel-on-windows.patch working from 5.39 to 5.60
  #  * stunnel-on-windows-new.patch working from 5.61 to the latest for the time being.
  #
  # TODO: Find a better way to patch by version
  patch source: "stunnel-on-windows#{"-new" if version.satisfies?("> 5.60")}.patch", plevel: 1, env: env if windows?

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
    target = (mingw == "mingw32" ? "mingw" : "mingw64")

    # Setting the binary directory as target
    bin_dir = target
    # After v5.50, the binaries are created on different directory based on arch
    # eg: from stunnel-5.50/src/mingw.mk
    # win32_arch=win64
    # bindir = ../bin/$(win32_arch)
    bin_dir = (mingw == "mingw32" ? "win32" : "win64") if version.satisfies?(">= 5.50")

    # Starting omnibus-toolchain version 1.1.115 we do not build msys2 as a part of omnibus-toolchain anymore, but pre install it in image
    # so here we set the path to default install of msys2 first and default to OMNIBUS_TOOLCHAIN_INSTALL_DIR for backward compatibility
    msys_path = ENV["MSYS2_INSTALL_DIR"] ? "#{ENV["MSYS2_INSTALL_DIR"]}" : "#{ENV["OMNIBUS_TOOLCHAIN_INSTALL_DIR"]}/embedded/bin"

    make target, env: env, cwd: "#{project_dir}/src"

    block "copy required windows files" do
      copy_files = %W{
        #{project_dir}/bin/#{bin_dir}/stunnel.exe
        #{project_dir}/bin/#{bin_dir}/tstunnel.exe
        #{msys_path}/#{mingw}/bin/libssp-0.dll}

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
