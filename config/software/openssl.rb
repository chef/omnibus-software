#
# Copyright 2012-2015 Chef Software, Inc.
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

name "openssl"

fips_enabled = (project.overrides[:fips] && project.overrides[:fips][:enabled]) || false

dependency "zlib"
dependency "cacerts"
dependency "makedepend" unless aix? || windows?
dependency "patch" if solaris2? || windows?
dependency "mingw" if windows?
dependency "openssl-fips" if fips_enabled

default_version "1.0.1q"

source url: "https://www.openssl.org/source/openssl-#{version}.tar.gz"

version("1.0.1m") { source md5: "d143d1555d842a069cb7cc34ba745a06" }
version("1.0.1p") { source md5: "7563e92327199e0067ccd0f79f436976" }
version("1.0.1q") { source md5: "54538d0cdcb912f9bc2b36268388205e" }

relative_path "openssl-#{version}"

build do

  env = with_standard_compiler_flags(with_embedded_path)
  if ohai["platform"] == "aix"
    env["M4"] = "/opt/freeware/bin/m4"
  end

  configure_args = [
    "--prefix=#{install_dir}/embedded",
    "--with-zlib-lib=#{install_dir}/embedded/lib",
    "--with-zlib-include=#{install_dir}/embedded/include",
    "no-idea",
    "no-mdc2",
    "no-rc5",
    "zlib",
    "shared",
    env['LDFLAGS'],
    env['CFLAGS'],
  ]

  if fips_enabled
    configure_args << "--with-fipsdir=#{install_dir}/embedded" << "fips"
  end

  configure_cmd =
    case ohai["platform"]
    when "aix"
      "perl ./Configure aix64-cc"
    when "mac_os_x"
      "./Configure darwin64-x86_64-cc"
    when "smartos"
      "/bin/bash ./Configure solaris64-x86_64-gcc -static-libgcc"
    when "solaris2"
      # This should not require a /bin/sh, but without it we get
      # Errno::ENOEXEC: Exec format error
      platform =
        if ohai["kernel"]["machine"] =~ /sun/
          "solaris-sparcv9-gcc"
        else
          "solaris-x86-gcc"
        end
      "/bin/sh ./Configure #{platform}"
    when "windows"
      platform = windows_arch_i386? ? "mingw" : "mingw64"
      "perl.exe ./Configure #{platform}"
    else
      prefix =
        if ohai["os"] == "linux" && ohai["kernel"]["machine"] == "ppc64"
          "./Configure linux-ppc64"
        elsif ohai["os"] == "linux" && ohai["kernel"]["machine"] == "s390x"
          "./Configure linux64-s390x"
        else
          "./config"
        end
      "#{prefix} disable-gost"
    end

  if aix?

    # This enables omnibus to use 'makedepend'
    # from fileset 'X11.adt.imake' (AIX install media)
    env['PATH'] = "/usr/lpp/X11/bin:#{ENV["PATH"]}"

    patch_env = env.dup
    patch_env['PATH'] = "/opt/freeware/bin:#{env['PATH']}"
    patch source: "openssl-1.0.1f-do-not-build-docs.patch", env: patch_env
  else
    patch source: "openssl-1.0.1f-do-not-build-docs.patch", env: env
  end

  configure_command = configure_args.unshift(configure_cmd).join(" ")

  command configure_command, env: env
  make "depend", env: env
  # make -j N on openssl is not reliable
  make env: env
  if aix?
    # We have to sudo this because you can't actually run slibclean without being root.
    # Something in openssl changed in the build process so now it loads the libcrypto
    # and libssl libraries into AIX's shared library space during the first part of the
    # compile. This means we need to clear the space since it's not being used and we
    # can't install the library that is already in use. Ideally we would patch openssl
    # to make this not be an issue.
    # Bug Ref: http://rt.openssl.org/Ticket/Display.html?id=2986&user=guest&pass=guest
    command "sudo /usr/sbin/slibclean", env: env
  end
  make "install", env: env
end
