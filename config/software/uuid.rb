name "uuid"
default_version "1.30"

dependency "python"
dependency "pip"

build do
  ship_license "PSFL"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end