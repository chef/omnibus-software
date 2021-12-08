name "uptime"
default_version "3.0.1"

dependency "python"
dependency "pip"

build do
  license "BSD-2-Clause"
  license_file "https://raw.githubusercontent.com/Cairnarvon/uptime/master/COPYING.txt"
  pip "install --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end
