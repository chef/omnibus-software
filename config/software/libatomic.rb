name "libatomic"
default_version "7.5.0"
dependency "gmp"
dependency "mpfr"
dependency "mpc"

# Version list: url=https://ftp.gnu.org/gnu/gcc/ filter=*.tar.gz
version("7.5.0") { source sha256: "4f518f18cfb694ad7975064e99e200fe98af13603b47e67e801ba9580e50a07f" }
source url: "https://mirrors.kernel.org/gnu/gcc/gcc-#{version}/gcc-#{version}.tar.gz"

relative_path "gcc-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
   # Install texinfo if on a Red Hat-based system
  # Check the OS and install texinfo if on a Red Hat-based system
  if File.exist?("/usr/bin/yum")
    command "yum install -y texinfo", env: env
  elsif File.exist?("/usr/bin/apt-get")
    command "apt-get update && apt-get install -y texinfo", env: env
  else
    puts "Warning: No package manager found. Texinfo installation skipped."
  end

  env["CFLAGS"] << " -fno-lto"
  env["CXXFLAGS"] << " -fno-lto"
  #export LDFLAGS="-L/path/to/libmpc -L/path/to/libmpfr -L/path/to/libgmp"
  # Set the library paths
  mpc_path = "/usr/lib/x86_64-linux-gnu"
  mpfr_path = "/usr/lib/x86_64-linux-gnu"
  gmp_path = "/usr/lib/x86_64-linux-gnu"

  # Configure GCC with explicit library paths
  command "./configure --prefix=#{install_dir}/embedded --enable-shared --disable-nls --disable-multilib --with-mpc=#{mpc_path} --with-mpfr=#{mpfr_path} --with-gmp=#{gmp_path}", env: env
  # Build the entire GCC, which includes libatomic
  command "make -j #{workers}", env: env

  # Install only libatomic
  command "make install-libatomic", env: env

  # Create a symlink for libatomic.so.1
  command "cd #{install_dir}/embedded/lib && ln -s libatomic.so.1 libatomic.so", env: env
end