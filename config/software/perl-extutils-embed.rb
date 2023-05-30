name "perl-extutils-embed"
default_version "1.14"

dependency "perl"

source url: "https://search.cpan.org/CPAN/authors/id/D/DO/DOUGM/ExtUtils-Embed-#{version}.tar.gz",
       sha256: "f0e455c51ea1db5c43152d636cd667b6598972e5845500ca4d9344f339c0a5f0"

relative_path "ExtUtils-Embed-#{version}"

build do
  command "#{install_dir}/embedded/bin/perl Makefile.PL INSTALL_BASE=#{install_dir}/embedded"
  command "make -j #{workers}"
  command "make install"
end
