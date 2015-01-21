name "paramiko"
default_version "1.15.1"

dependency "python"
dependency "pip"

build do
  license "https://raw.githubusercontent.com/paramiko/paramiko/master/LICENSE"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end