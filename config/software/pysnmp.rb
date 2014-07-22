name "pysnmp"
default_version "4.2.5"

dependency "python"
dependency "pip"
dependency "pysnmp-mibs"

build do
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end
