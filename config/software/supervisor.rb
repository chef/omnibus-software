name "supervisor"
default_version "3.1.2"

dependency "python"
dependency "pip"

build do
  license "https://raw.githubusercontent.com/Supervisor/supervisor/master/LICENSES.txt"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end