name "dep-selector-libgecode"
default_version "1.3.1"
license "Apache-2.0"
license_file "https://raw.githubusercontent.com/chef/dep-selector-libgecode/master/LICENSE"
skip_transitive_dependency_licensing true
dependency "ruby"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # On some RHEL-based systems, the default GCC that's installed is 4.1.
  # Ubuntu 24.04 has GCC 13 which may create compatibility issues with some libraries.
  # Optionally fallback to use system Gecode to avoid building vendored source.
  if ENV['USE_SYSTEM_GECODE'] == '1'
    gem "install dep-selector-libgecode --version '#{version}' --no-document -- --use-system-gecode", env: env
  else
    # For Ubuntu 24.04, explicitly set newer flags to ensure compatibility
    env["CFLAGS"] = "#{env["CFLAGS"]} -fcommon -D_GLIBCXX_USE_CXX11_ABI=0" if `lsb_release -rs`.chomp == '24.04'
    
    # Use gcc44/g++44 if present (mostly for older RHEL)
    if File.exist?("/usr/bin/gcc44")
      env["CC"]  = "gcc44"
      env["CXX"] = "g++44"
    end
    
    env["ARFLAGS"] = "rv #{env["ARFLAGS"]}" if env["ARFLAGS"]
    env["PROG_TAR"] = "bsdtar" if windows?
    
    gem "install dep-selector-libgecode --version '#{version}' --no-document", env: env
  end
end
