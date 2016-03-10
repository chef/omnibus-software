name "pyvmomi"
default_version "6.0.0"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/vmware/pyvmomi/master/LICENSE.txt"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end
