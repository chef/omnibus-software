name "percona-xtrabackup"
default_version "2.4.9"

skip_transitive_dependency_licensing true

source url: "https://github.com/percona/percona-xtrabackup/archive/percona-xtrabackup-2.4.9.tar.gz",
       :md5 => "be54cc7f8843fcfa3334917b732ac234",
       :extract => :seven_zip
relative_path "percona-xtrabackup-percona-xtrabackup-2.4.9"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  command "cmake -DBUILD_CONFIG=xtrabackup_release " \
          "-DWITH_MAN_PAGES=OFF -DDOWNLOAD_BOOST=1 " \
          "-DWITH_BOOST=#{install_dir}/embedded/lib/boost_1_59_0", env: env

  make "prefix=#{install_dir}/embedded -j #{workers}", env: env
  make "prefix=#{install_dir}/embedded install", env: env
end