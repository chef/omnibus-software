name "perl"
default_version "5.18.1"

source :url => "http://www.cpan.org/src/5.0/perl-#{version}.tar.gz",
       :md5 => "304cb5bd18e48c44edd6053337d3386d"

relative_path "perl-#{version}"

env = {
  "LDFLAGS" => "-L#{install_path}/embedded/lib -I#{install_path}/embedded/include",
  "CFLAGS" => "-L#{install_path}/embedded/lib -I#{install_path}/embedded/include",
  "LD_RUN_PATH" => "#{install_path}/embedded/lib"
}

build do
  command [
            "sh Configure",
            "-de",
            "-Dprefix=#{install_path}/embedded",
            "-Duseshrplib", ## Compile shared libperl
            "-Dusethreads", ## Compile ithread support
            "-Dnoextensions='DB_File GDBM_File NDBM_File ODBM_File'"
           ].join(" "), :env => env
  command "make -j #{max_build_jobs}"
  command "make install", :env => env
end
