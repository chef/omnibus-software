name "pyro4"
default_version "4.29"

dependency "python"
dependency "pip"

build do
  license "https://raw.githubusercontent.com/irmen/Pyro4/master/LICENSE"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" Pyro4==#{version}"
end