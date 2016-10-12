name "pyyaml"
default_version "3.11"

dependency "python"
dependency "pip"
dependency "libyaml"

build do
  ship_license "http://dd-agent-omnibus.s3.amazonaws.com/pyyaml-LICENSE"
  command "#{install_dir}/embedded/bin/pip install --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end
