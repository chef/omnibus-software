#
# Copyright 2014 Chef Software, Inc.
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

name "openssl-fips"
default_version "2.0.10"

if windows?
  dependency "patch"
  dependency "mingw"
  dependency "perl"
end

version("2.0.9") { source md5: "c8256051d7a76471c6ad4fb771404e60" }
version("2.0.10") { source sha256: "a42ccf5f08a8b510c0c78da1ba889532a0ce24e772b576604faf09b4d6a0f771" }

# HAHAHA According to the FIPS manual, you need to "securely" fetch the source
# such as asking some humans to mail you a CD-ROM or something.
# You are then supposed to manually verify the PGP signatures.
# When making an "official" build - make sure you go do that...
source url: "https://www.openssl.org/source/openssl-fips-#{version}.tar.gz", extract: :lax_tar

relative_path "openssl-fips-#{version}"


build do
  # According to the FIPS manual, this is the only environment you are allowed
  # to build it in, to ensure security.
  env = {}
  env['FIPSDIR'] = "#{install_dir}/embedded"


  if windows?
    # The cross-toolchain we have won't work out of the box on windows for 32-bit.
    # This sucks.  Maybe eventually we'll use Visual Studio?
    env = with_standard_compiler_flags(with_embedded_path({}, msys: true), bfd_flags: true)

    if windows_arch_i386?
      # Patch Makefile.shared to let us set the bit-ness of the resource compiler.
      patch source: "openssl-fips-take-windres-rcflags.patch", env: env
      # Patch Makefile.org to update the compiler flags/options table for mingw.
      patch source: "openssl-fips-fix-compiler-flags-table-for-msys.patch", env: env
      # Patch Configure to call ar.exe without anooying it.
      patch source: "openssl-fips-ar-needs-operation-before-target.patch", env: env

      platform = "mingw"
    else
      platform = "mingw64"
    end

    configure_command = ["perl.exe ./Configure #{platform}"]
    configure_command << "--prefix=#{install_dir}/embedded"
  else
    configure_command = ["./config"]
  end

  command configure_command.join(" "), env: env, in_msys_bash: true

  # Cannot use -j with openssl :(.
  make env: env
  make "install", env: env
end
