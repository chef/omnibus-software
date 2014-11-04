name "pyro4"
default_version "4.29"

dependency "python"
dependency "pip"

build do
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" Pyro4==#{version}"
end