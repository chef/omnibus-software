name "supervisor"
default_version "3.3.0"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/Supervisor/supervisor/master/LICENSES.txt"
  pip_call "install --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end
