name "psycopg2"
default_version "2.6.2"

dependency "python"
dependency "pip"
dependency "libpq"

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}",
}

build do
  ship_license "https://raw.githubusercontent.com/psycopg/psycopg2/master/LICENSE"
  pip "install #{name}==#{version}", :env => env
end
