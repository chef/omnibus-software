#
# Copyright 2015 Chef Software, Inc.
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
# expeditor/ignore: no version pinning

name "delivery-cli"
# Delivery CLI is only pushed to the main branch of Github after it
# is successfully Delivered. So pulling in the "main" version
# will always give you the latest Delivered version.
default_version "main"

license "Apache-2.0"
license_file "LICENSE"

source git: "https://github.com/chef/delivery-cli.git"

dependency "openssl"
dependency "rust"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env["RUST_BACKTRACE"] = "1"

  # The rust core libraries are dynamicaly linked
  if linux?
    env["LD_LIBRARY_PATH"] = "#{install_dir}/embedded/lib"
  elsif mac_os_x? &&
      platform_version.satisfies?("< 10.13") # Setting DYLD PATH fails builds with library conflicts in 10.13
    env["DYLD_FALLBACK_LIBRARY_PATH"] = "#{install_dir}/embedded/lib:"
  end

  # pass version info into the build
  env["DELIV_CLI_VERSION"] = version
  env["DELIV_CLI_GIT_SHA"] = Omnibus::Fetcher.resolve_version(version, source)

  if windows?
    copy "#{install_dir}/embedded/bin/ssleay32.dll", "#{install_dir}/embedded/bin/libssl32.dll"
    env["OPENSSL_LIB_DIR"] = "#{install_dir}/embedded/bin"
  end

  command "cargo build -j #{workers} --release", env: env

  mkdir "#{install_dir}/bin"

  if windows?
    copy "#{project_dir}/target/release/delivery.exe", "#{install_dir}/bin/delivery.exe"
    # When using `openssl` dependency, by default it builds the libraries inside
    # `embedded/bin/`. We are copying the libs inside `bin/`.
    copy "#{install_dir}/embedded/bin/ssleay32.dll", "#{install_dir}/bin/ssleay32.dll"
    copy "#{install_dir}/embedded/bin/libeay32.dll", "#{install_dir}/bin/libeay32.dll"
    copy "#{install_dir}/embedded/bin/zlib1.dll", "#{install_dir}/bin/zlib1.dll"

    # Needed now that we switched to installed version of msys2 and have not figured out how to tell
    # it how to statically link yet
    dlls = ["libwinpthread-1"]
    if windows_arch_i386?
      dlls << "libgcc_s_dw2-1"
    else
      dlls << "libgcc_s_seh-1"
    end
    dlls.each do |dll|
      mingw = ENV["MSYSTEM"].downcase
      # Starting omnibus-toolchain version 1.1.115 we do not build msys2 as a part of omnibus-toolchain anymore, but pre install it in image
      # so here we set the path to default install of msys2 first and default to OMNIBUS_TOOLCHAIN_INSTALL_DIR for backward compatibility
      msys_path = ENV["MSYS2_INSTALL_DIR"] ? "#{ENV["MSYS2_INSTALL_DIR"]}" : "#{ENV["OMNIBUS_TOOLCHAIN_INSTALL_DIR"]}/embedded/bin"
      windows_path = "#{msys_path}/#{mingw}/bin/#{dll}.dll"
      if File.exist?(windows_path)
        copy windows_path, "#{install_dir}/bin/#{dll}.dll"
      else
        raise "Cannot find required DLL needed for dynamic linking: #{windows_path}"
      end
    end

  else
    copy "#{project_dir}/target/release/delivery", "#{install_dir}/bin/delivery"
  end
end
