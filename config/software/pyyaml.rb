name "pyyaml"
default_version "3.10"

dependency "python"
dependency "pip"
dependency "libyaml"

build do
  command "#{install_dir}/embedded/bin/pip install -I --build #{project_dir} --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end
