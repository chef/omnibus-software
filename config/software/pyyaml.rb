name "pyyaml"
default_version "3.11"

dependency "python"
dependency "pip"
dependency "libyaml"

build do
  ship_license "http://pyyaml.org/export/385/pyyaml/trunk/LICENSE"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end