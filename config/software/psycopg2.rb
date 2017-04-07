name "psycopg2"
default_version "2.7.1"

dependency "python"
dependency "pip"

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}",
}

whitelist_file 'psycopg2\/.libs'

build do
  ship_license "https://raw.githubusercontent.com/psycopg/psycopg2/master/LICENSE"
  pip "install #{name}==#{version}", :env => env
end
