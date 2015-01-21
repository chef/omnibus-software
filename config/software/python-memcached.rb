name "python-memcached"
default_version "1.53"

dependency "python"
dependency "pip"

build do
  license "PSFL"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end