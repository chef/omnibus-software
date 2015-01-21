name "kazoo"
default_version "1.3.1"

dependency "python"
dependency "pip"

build do
  license "Apachev2"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end