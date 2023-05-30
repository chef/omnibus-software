name "perl-extutils-makemaker"
default_version "6.78"

dependency "perl"

source url: "https://search.cpan.org/CPAN/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-#{version}.tar.gz",
       sha256: "f006da72a405c53aca948cc563beca30ced0536dc3346469a3e932eda92a9947"

relative_path "ExtUtils-MakeMaker-#{version}"

build do
  command "#{install_dir}/embedded/bin/perl Makefile.PL INSTALL_BASE=#{install_dir}/embedded"
  command "make -j #{workers}"
  command "make install"
end
