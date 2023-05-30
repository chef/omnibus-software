name "bison"
default_version "3.0.4"

relative_path "bison-3.0.4"

source url: "https://ftp.gnu.org/gnu/bison/bison-3.0.4.tar.gz",
       sha256: "b67fd2daae7a64b5ba862c66c07c1addb9e6b1b05c5f2049392cfd8a2172952e"

env = with_standard_compiler_flags

build do
  command "./configure --prefix=#{install_dir}/embedded", env: env
  command "make -j #{workers}", env: env
  command "make -j #{workers} install", env: env
end
