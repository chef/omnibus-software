name "percona-xtrabackup"
default_version "2.4.9"

source url: "https://github.com/percona/percona-xtrabackup/archive/percona-xtrabackup-2.4.9.tar.gz",
       md5: "a652101df66cc8eed92824d316f41766"

relative_path "percona-xtrabackup-percona-xtrabackup-2.4.9"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  command "cmake -DBUILD_CONFIG=xtrabackup_release && make -j4", env: env
  command "make install", env: env
end