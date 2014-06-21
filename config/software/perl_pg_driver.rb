name "perl_pg_driver"

dependency "perl"
dependency "cpanminus"
dependency "postgresql"

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}"
}

build do
  command "cpanm -v --notest DBD::Pg", :env => env
end
