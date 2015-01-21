name "httplib2"
default_version "0.9"

dependency "python"
dependency "pip"

build do
  license "https://raw.githubusercontent.com/jcgregorio/httplib2/master/LICENSE"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end