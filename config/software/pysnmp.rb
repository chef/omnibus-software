name "pysnmp"
default_version "4.2.5"

resource_name "pysnmp-mibs"
resource_version "0.1.4"

dependency "python"
dependency "pip"

build do
  command "#{install_dir}/embedded/bin/pip install -I --build #{project_dir} --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  command "#{install_dir}/embedded/bin/pip install -I --build #{project_dir} --install-option=\"--install-scripts=#{install_dir}/bin\" #{resource_name}==#{resource_version}"
end


