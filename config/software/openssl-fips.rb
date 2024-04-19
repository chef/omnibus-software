#
# Copyright 2014-2019 Chef Software, Inc.
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
default_version "2.0.16"

license "OpenSSL"
license_file "https://www.openssl.org/source/license.html"
skip_transitive_dependency_licensing true

# HAHAHA According to the FIPS manual, you need to "securely" fetch the source
# such as asking some humans to mail you a CD-ROM or something.
# You are then supposed to manually verify the PGP signatures.
# When making an "official" build - make sure you go do that...
source url: "https://www.openssl.org/source/old/fips/openssl-fips-#{version}.tar.gz", extract: :lax_tar
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz", extract: :lax_tar,
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

version("2.0.16") {
  source sha256: "a3cd13d0521d22dd939063d3b4a0d4ce24494374b91408a05bdaca8b681c63d4", \
         url: "https://www.openssl.org/source/openssl-fips-#{version}.tar.gz", extract: :lax_tar
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz", extract: :lax_tar,
                  authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
}
version("2.0.14") { source sha256: "8ea069ec39f9c49d85b9831b16daa29936b4527446998336cf93e575f07626c0" }
version("2.0.11") { source sha256: "a6532875956d357a05838ca2c9865b8eecac211543e4246512684b17acbbdfac" }
version("2.0.10") { source sha256: "a42ccf5f08a8b510c0c78da1ba889532a0ce24e772b576604faf09b4d6a0f771" }
version("2.0.9") { source md5: "c8256051d7a76471c6ad4fb771404e60" }

relative_path "openssl-fips-#{version}"

build do
  # According to the FIPS manual, this is the only environment you are allowed
  # to build it in, to ensure security.
  env = {}
  env["FIPSDIR"] = "#{install_dir}/embedded"

  if windows?
    default_env = with_standard_compiler_flags(with_embedded_path)

    if windows_arch_i386?
      # Patch Makefile.org to update the compiler flags/options table for mingw.
      patch source: "openssl-fips-fix-compiler-flags-table-for-msys.patch", env: default_env

      platform = "mingw"
    else
      platform = "mingw64"
    end

    configure_command = ["perl.exe ./Configure #{platform}"]
    configure_command << "--prefix=#{install_dir}/embedded"
  elsif ppc64? && rhel?
    # you have to specify on el ppc64 (big-endian only) otherwise it has won't
    # compile
    configure_command = ["perl ./Configure linux-ppc64"]
    configure_command << "--prefix=#{install_dir}/embedded"
  elsif s390x?
    configure_command = ["perl ./Configure linux64-s390x"]
    configure_command << "--prefix=#{install_dir}/embedded"
    # Unfortunately openssl-fips is not supported on s390x, so we have to tell it to
    # compile solely in C
    configure_command << "no-asm"
  else
    configure_command = ["./config"]
  end

  command configure_command.join(" "), env: env, in_msys_bash: true

  # Cannot use -j with openssl :(.
  make env: env
  make "install", env: env
end
