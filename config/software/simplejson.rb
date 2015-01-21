name "simplejson"
default_version "3.6.4"

dependency "python"
dependency "pip"

build do
  license "https://raw.githubusercontent.com/simplejson/simplejson/master/LICENSE.txt"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end