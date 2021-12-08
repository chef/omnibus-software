name "python-consul"
default_version "0.4.7"

dependency "python"
dependency "pip"

build do
  license "MIT"
  license_file "https://raw.githubusercontent.com/cablehead/python-consul/master/LICENSE"
  pip "install --install-option=\"--install-scripts=#{install_dir}/bin\" python-consul==#{version}"
end
