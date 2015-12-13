name "psycopg2"
default_version "2.6"

dependency "python"
dependency "pip"
dependency "libpq"

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}

build do
  ship_license "https://raw.githubusercontent.com/psycopg/psycopg2/master/LICENSE"
  # if ohai['platform'] == 'windows'
  #   command "CMD /C \"SET Path=\\\"#{ENV['PATH']}:\\embedded\\Scripts\\\" && "
  #           "#{install_dir}/embedded/Scripts/pip install -I #{name}==#{version} "\
  # else
  #   command "#{install_dir}/embedded/bin/pip install -I #{name}==#{version}", :env => env
  # end
  pip "install #{name}==#{version}", :env => env
end
