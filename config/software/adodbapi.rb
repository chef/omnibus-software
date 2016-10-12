name "adodbapi"
default_version "2.6.0.7"

dependency "python"
dependency "pip"
dependency "pyro4"

build do
  ship_license "LGPLv2"
  command "#{install_dir}/embedded/bin/pip install --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end
