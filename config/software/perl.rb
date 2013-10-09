name "perl"
version "5.18.1"

source :url => "http://www.cpan.org/src/5.0/perl-#{version}.tar.gz",
       :md5 => "304cb5bd18e48c44edd6053337d3386d"

relative_path "perl-#{version}"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  command [
            "sh Configure",
            "-de",
            "-Dprefix=#{install_dir}/embedded",
            "-Duseshrplib", ## Compile shared libperl
            "-Dusethreads" ## Compile ithread support
           ].join(" "), :env => env
  command "make -j #{max_build_jobs}"
  command "make install", :env => env
end
