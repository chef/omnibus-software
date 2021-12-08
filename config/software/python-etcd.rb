name "python-etcd"
default_version "0.4.5"

dependency "python"
dependency "python-urllib3"
dependency "pip"

build do
  license "MIT"
  license_file "https://raw.githubusercontent.com/jplana/python-etcd/master/LICENSE.txt"
  pip "install --install-option=\"--install-scripts=#{install_dir}/bin\" python-etcd==#{version}"
end
