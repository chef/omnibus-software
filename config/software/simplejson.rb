name "simplejson"
default_version "3.6.5"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/simplejson/simplejson/master/LICENSE.txt"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end