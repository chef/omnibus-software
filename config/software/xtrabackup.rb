name "percona-xtrabackup"
default_version "2.4.9"

skip_transitive_dependency_licensing true

source url: "https://github.com/percona/percona-xtrabackup/archive/percona-xtrabackup-2.4.9.tar.gz",
       sha256: "53e613e12dbd93277fb3004b66d8d2c12476e4febca2bcd2d0f2115dc18cb265"

relative_path "percona-xtrabackup-percona-xtrabackup-2.4.9"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  command "cmake -DBUILD_CONFIG=xtrabackup_release " \
          "-DWITH_MAN_PAGES=OFF -DDOWNLOAD_BOOST=1 " \
          "-DWITH_BOOST=#{install_dir}/embedded/lib/boost_1_59_0", env: env

  make "prefix=#{install_dir}/embedded -j #{workers}", env: env
  make "prefix=#{install_dir}/embedded install", env: env
end