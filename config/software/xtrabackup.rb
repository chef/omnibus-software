name 'xtrabackup'
default_version '2.4.13'

skip_transitive_dependency_licensing true
dependency 'libffi'

version('2.4.12') { source md5: 'c086206421a77f7c1ad28771a75cf396'}
version('2.4.13') { source md5: 'f8a5170e0e6a6b26125ba935298452c1'}

source url: "https://s3.amazonaws.com/twindb-release/percona-xtrabackup-#{version}.tar.gz"

relative_path "percona-xtrabackup-#{version}"
whitelist_file /.*/

workers = 2

build do
    env = with_standard_compiler_flags(with_embedded_path)
    command 'cmake -DBUILD_CONFIG=xtrabackup_release ' \
          '-DWITH_MAN_PAGES=OFF -DDOWNLOAD_BOOST=1 ' \
          "-DWITH_BOOST=#{install_dir}/libboost " \
          '-DWITH_SSL=system ' \
          "-DINSTALL_BINDIR=#{install_dir}/embedded/bin", env: env

    make "-j #{workers}", env: env
    make 'install', env: env
    delete "#{install_dir}/libboost"
end
