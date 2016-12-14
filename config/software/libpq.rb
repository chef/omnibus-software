name "libpq"
default_version "9.4.0"


if ohai['platform'] != 'windows'

  source :url => "http://ftp.postgresql.org/pub/source/v#{version}/postgresql-#{version}.tar.gz",
         :md5 => "349552802c809c4e8b09d8045a437787"

  dependency "zlib"
  dependency "openssl"
  dependency "libedit"
  dependency "ncurses"

  relative_path "postgresql-#{version}"

  env = {
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
  }


  build do
    ship_license "https://raw.githubusercontent.com/lpsmith/postgresql-libpq/master/LICENSE"
    command [ "./configure",
              "--prefix=#{install_dir}/embedded",
              "--with-libedit-preferred",
              "--with-openssl",
              "--with-includes=#{install_dir}/embedded/include",
              "--with-libraries=#{install_dir}/embedded/lib" ].join(" "), :env => env
    command "make -j #{workers}", :env => { "LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
    mkdir "#{install_dir}/embedded/include/postgresql"
    command "make -C src/include install"
    command "make -C src/interfaces install"
    command "make -C src/bin/pg_config install"
  end

else
  dependency 'pgsql'
end
