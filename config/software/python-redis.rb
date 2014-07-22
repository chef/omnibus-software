name "python-redis"
default_version "2.10.1"

dependency "python"
dependency "pip"

build do
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" redis==#{version}"
end
