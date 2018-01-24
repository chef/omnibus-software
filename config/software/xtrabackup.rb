name "percona-xtrabackup"
default_version "2.4.9"

source url: "https://github.com/percona/percona-xtrabackup/archive/percona-xtrabackup-2.4.9.tar.gz",
       :sha256 => "53e613e12dbd93277fb3004b66d8d2c12476e4febca2bcd2d0f2115dc18cb265",
       :extract => :seven_zip
relative_path "percona-xtrabackup-percona-xtrabackup-2.4.9"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  command "cmake -DBUILD_CONFIG=xtrabackup_release -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/usr/local/boost_1_59_0", env: env
  make "-j #{workers}", env: env
  make "install", env: env
  command "mv -v /usr/local/xtrabackup/bin/* /usr/bin/"
end