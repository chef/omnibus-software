name "python-consul"
default_version "0.4.7"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/cablehead/python-consul/master/LICENSE"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" python-consul==#{version}"
end
