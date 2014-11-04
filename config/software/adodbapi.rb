name "adodbapi"
default_version "2.6.0.7"

dependency "python"
dependency "pip"
dependency "pyro4"

build do
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end