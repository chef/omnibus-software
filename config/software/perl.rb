name "perl"
default_version "5.18.1"

source url: "https://www.cpan.org/src/5.0/perl-#{version}.tar.gz",
       sha256: "655e11a8ffba8853efcdce568a142c232600ed120ac24aaebb4e6efe74e85b2b"

relative_path "perl-#{version}"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
}

build do
  command [
            "sh Configure",
            "-de",
            "-Dprefix=#{install_dir}/embedded",
            "-Duseshrplib", ## Compile shared libperl
            "-Dusethreads", ## Compile ithread support
            "-Dnoextensions='DB_File GDBM_File NDBM_File ODBM_File'",
           ].join(" "), env: env
  command "make -j #{workers}"
  command "make install", env: env
end
