name "pyvmomi"
default_version "5.5.0.2014.1.1"

dependency "python"
dependency "pip"

build do
  license "https://raw.githubusercontent.com/vmware/pyvmomi/master/LICENSE.txt"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end