#
# Copyright:: Copyright (c) Chef Software Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
#
# You may not use this file except in compliance with the License.
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

license "OpenSSL"
license_file "LICENSE"
skip_transitive_dependency_licensing true

# Override default version if CI_OPENSSL_VERSION is set (this is used in CI for ruby software testing)
default_version ENV["CI_OPENSSL_VERSION"] || "1.0.2zg" # do_not_auto_update

dependency "cacerts"
dependency "openssl-fips" if fips_mode? && !(version.satisfies?(">= 3.0.0"))

# Engine directories for Omnibus to sign on macOS
lib_dirs lib_dirs.concat(["#{install_dir}/embedded/lib/engines"])
lib_dirs lib_dirs.concat(["#{install_dir}/embedded/lib/engines-1.1"]) if version.start_with?("1.1")
if version.start_with?("3.")
  lib_dirs lib_dirs.concat(["#{install_dir}/embedded/lib/engines-3"])
  lib_dirs lib_dirs.concat(["#{install_dir}/embedded/lib/ossl-modules"])
end

# Source URLs and sha256 versions
if version.satisfies?("< 1.1.0")
  source url: "https://s3.amazonaws.com/chef-releng/openssl/openssl-#{version}.tar.gz", extract: :lax_tar
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz", extract: :lax_tar,
                  authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
else
  source url: "https://www.openssl.org/source/openssl-#{version}.tar.gz", extract: :lax_tar
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz", extract: :lax_tar,
                  authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end

version("3.2.4") { source sha256: "b23ad7fd9f73e43ad1767e636040e88ba7c9e5775bfa5618436a0dd2c17c3716" }
version("3.3.3") { source sha256: "712590fd20aaa60ec75d778fe5b810d6b829ca7fb1e530577917a131f9105539" }
version("3.4.1") { source sha256: "002a2d6b30b58bf4bea46c43bdd96365aaf8daa6c428782aa4feee06da197df3" }

version("3.1.2") { source sha256: "a0ce69b8b97ea6a35b96875235aa453b966ba3cba8af2de23657d8b6767d6539" } # FIPS validated

version("3.0.15") { source sha256: "23c666d0edf20f14249f36acaee9ab585b09e1de82107c66e1f3ec9533" }
# Add other versions as needed

relative_path "openssl-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Platform specific environment adjustments
  if aix?
    env["M4"] = "/opt/freeware/bin/m4"
  elsif mac_os_x? && arm?
    env["CFLAGS"] << " -Qunused-arguments"
  elsif windows?
    env["CFLAGS"] = "-I#{install_dir}/embedded/include"
    env["CPPFLAGS"] = env["CFLAGS"]
    env["CXXFLAGS"] = env["CFLAGS"]
  end

  # Configure args
  configure_args = [
    "--prefix=#{install_dir}/embedded",
    "no-unit-test",
    "no-comp",
    "no-idea",
    "no-mdc2",
    "no-rc5",
    "no-ssl2",
    "no-ssl3",
    "no-zlib",
    "shared",
  ]

  configure_args += ["--libdir=#{install_dir}/embedded/lib"] if version.satisfies?(">=3.0.1")

  if version.satisfies?(">= 1.0.2zb") && version.satisfies?("< 1.1.0")
    configure_args << "-DOPENSSL_TRUSTED_FIRST_DEFAULT"
  end

  if version.satisfies?("< 3.0.0")
    configure_args += ["--with-fipsdir=#{install_dir}/embedded", "fips"] if fips_mode?
  else
    configure_args << "enable-fips" if fips_mode?
  end

  configure_cmd =
    if aix?
      "perl ./Configure aix64-cc"
    elsif mac_os_x?
      intel? ? "./Configure darwin64-x86_64-cc" : "./Configure darwin64-arm64-cc no-asm"
    elsif smartos?
      "/bin/bash ./Configure solaris64-x86_64-gcc -static-libgcc"
    elsif omnios?
      "/bin/bash ./Configure solaris-x86-gcc"
    elsif solaris2?
      platform = sparc? ? "solaris64-sparcv9-gcc" : "solaris64-x86_64-gcc"
      if version.satisfies?("< 1.1.0")
        "/bin/bash ./Configure #{platform} -static-libgcc"
      else
        "./Configure #{platform} -static-libgcc"
      end
    elsif windows?
      platform = "mingw64"
      "perl.exe ./Configure #{platform}"
    else
      prefix =
        if linux? && ppc64?
          "./Configure linux-ppc64"
        elsif linux? && s390x?
          "./Configure linux64-s390x -DOPENSSL_NO_INLINE_ASM"
        else
          "./config"
        end
      "#{prefix} disable-gost"
    end

  patch_env = if aix?
                env["PATH"] = "/usr/lpp/X11/bin:#{ENV["PATH"]}"
                penv = env.dup
                penv["PATH"] = "/opt/freeware/bin:#{env["PATH"]}"
                penv
              else
                env
              end

  # Conditional patching based on version for docs and legacy provider
  if version.start_with? "1.0"
    patch source: "openssl-1.0.1f-do-not-build-docs.patch", env: patch_env
  elsif version.start_with? "1.1"
    patch source: "openssl-1.1.0f-do-not-install-docs.patch", env: patch_env
  elsif version.start_with?("3.0") || version.start_with?("3.1")
    patch source: "openssl-3.0.1-do-not-install-docs.patch", env: patch_env
    configure_args << "enable-legacy"
    patch source: "openssl-3.0.0-enable-legacy-provider.patch", env: patch_env
  else
    patch source: "openssl-3.2.4-do-not-install-docs.patch", env: patch_env
    configure_args << "enable-legacy"
    patch source: "openssl-3.2.4-enable-legacy-provider.patch", env: patch_env
  end

  # Append CFLAGS last
  configure_args << env["CFLAGS"]

  configure_command = configure_args.unshift(configure_cmd).join(" ")

  command configure_command, env: env, in_msys_bash: true

  make "depend", env: env
  make env: env
  make "install", env: env

  # FIPS build for OpenSSL >= 3.0.0
  if fips_mode? && version.satisfies?(">= 3.0.0")
    openssl_fips_version = project.overrides.dig(:openssl, :fips_version) || "3.0.9"
    fips_dir = "openssl-#{openssl_fips_version}"

    command "wget https://www.openssl.org/source/openssl-#{openssl_fips_version}.tar.gz"
    command "tar -xf openssl-#{openssl_fips_version}.tar.gz"

    # Patch source/config files for -m32 -> -m64 on ppc64 el7
    if linux? && ppc64? && openssl_fips_version == "3.1.2"
      puts "==> [Omnibus OpenSSL] Patching -m32 to -m64 recursively in FIPS source tree for el7 ppc64"
      command("cd #{fips_dir} && find . \\( -name '*.c' -o -name '*.h' -o -name '*.inc' -o -name '*.conf' -o -name '*.pm' \\) -exec sed -i 's/\\-m32/-m64/g' {} +")
      command("cd #{fips_dir} && grep -r --color=always '-m32' . || echo '==> No -m32 flags found in FIPS source tree'")
    end

    command "cd #{fips_dir} && ./Configure linux-ppc64 enable-fips"

    # Verbose build with debug output to catch failures early
    command "cd #{fips_dir} && make VERBOSE=1 || (echo 'FIPS build failed, dumping last 40 lines:' && tail -40 build.log)"

    # Check and list object files and library archive
    command("cd #{fips_dir} && ls -l providers/*.o || echo 'No object files (*.o) found in providers'")
    command("cd #{fips_dir} && test -f providers/libfips.a && echo 'libfips.a successfully created' || echo 'ERROR: libfips.a missing!'")
    command("cd #{fips_dir} && ar -t providers/libfips.a || echo 'libfips.a not found or empty'")
    command("cd #{fips_dir} && nm providers/libfips.a | grep ppc || echo 'No PPC64 asm symbols found in libfips.a'")

    # Fail build if libfips.a missing to force investigation
    unless system("test -f #{fips_dir}/providers/libfips.a")
      fail "FIPS build failed to produce providers/libfips.a, halting build"
    end

    # Continue install
    fips_provider_path = "#{install_dir}/embedded/lib/ossl-modules/fips.#{windows? ? "dll" : "so"}"
    fips_cnf_file = "#{install_dir}/embedded/ssl/fipsmodule.cnf"

    command "#{install_dir}/embedded/bin/openssl fipsinstall -out #{fips_cnf_file} -module #{fips_provider_path}"
    command "cp #{fips_dir}/providers/fips.#{windows? ? "dll" : "so"} #{install_dir}/embedded/lib/ossl-modules/"
    command "cp #{fips_dir}/providers/fipsmodule.cnf #{install_dir}/embedded/ssl/"
    command "sed -i -e 's|# .include fipsmodule.cnf|.include #{fips_cnf_file}|g' #{install_dir}/embedded/ssl/openssl.cnf"
    command "sed -i -e 's|# fips = fips_sect|fips = fips_sect|g' #{install_dir}/embedded/ssl/openssl.cnf"
    command "#{install_dir}/embedded/bin/openssl list -providers"
  end
end
