name "boto"
default_version "2.25.0"
license "https://raw.githubusercontent.com/boto/boto/develop/LICENSE"
dependency "python"
dependency "pip"

build do
  license "https://raw.githubusercontent.com/boto/boto/develop/LICENSE"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end
