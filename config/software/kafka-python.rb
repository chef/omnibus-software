name "kafka-python"
default_version "0.9.0-9bed11db98387c0d9e456528130b330631dc50af"


dependency "python"
dependency "pip"

build do
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end
