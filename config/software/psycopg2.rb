name "psycopg2"
default_version "2.5.4"

dependency "python"
dependency "pip"
dependency "libpq"

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}

build do
  license "https://raw.githubusercontent.com/psycopg/psycopg2/master/LICENSE"
  command "#{install_dir}/embedded/bin/pip install -I #{name}==#{version}", :env => env
end
