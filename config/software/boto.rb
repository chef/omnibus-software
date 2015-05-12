name "boto"
default_version "2.36.0"
dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/boto/boto/develop/LICENSE"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end
