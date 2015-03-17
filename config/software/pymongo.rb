name "pymongo"
default_version "2.8"

dependency "python"
dependency "pip"

build do
  license "Apachev2"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end