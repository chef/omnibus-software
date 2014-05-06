name "perl_pg_driver"

dependency "perl"
dependency "postgresql"

# Ensure we install with the properly configured embedded `cpan` client
omnibus_cpan_client = "#{install_dir}/embedded/bin/cpan -j #{cache_dir}/cpan/OmnibusConfig.pm"

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}"
}

build do
  command "yes | #{omnibus_cpan_client} DBD::Pg", :env => env
end
