name "cython"
default_version "0.24"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/cython/cython/master/LICENSE.txt"
  command "#{install_dir}/embedded/bin/pip install --install-option=\"--no-cython-compile\" cython==#{version}"
end
