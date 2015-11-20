name "uptime"
default_version "3.0.1"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/Cairnarvon/uptime/master/COPYING.txt"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end
