name "datadogpy"
default_version "0.10.0"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/DataDog/datadogpy/master/LICENSE"
  command "#{install_dir}/embedded/bin/pip install --install-option=\"--install-scripts=#{install_dir}/bin\" datadog==#{version}"
end
