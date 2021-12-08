name "supervisor"
default_version "3.3.3"

dependency "python"
dependency "pip"

build do
  license "BSD-style"
  license_file "https://raw.githubusercontent.com/Supervisor/supervisor/master/LICENSES.txt"
  pip "install --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end
