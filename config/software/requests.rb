name "requests"
default_version "2.4.3"

dependency "python"
dependency "pip"

build do
  license "https://raw.githubusercontent.com/kennethreitz/requests/master/LICENSE"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end