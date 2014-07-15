name "tornado"
default_version "4.0"

dependency "python"
dependency "pip"
dependency "pycurl"
dependency "futures"

build do
  command "#{install_dir}/embedded/bin/pip install -I --build #{project_dir} --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end
