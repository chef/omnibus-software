name "requests"
default_version "2.6.2"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/kennethreitz/requests/master/LICENSE"
  command "#{install_dir}/embedded/bin/pip install --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end
