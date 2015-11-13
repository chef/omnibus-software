name "python-etcd"
default_version "0.4.2"

dependency "python"
dependency "pip"

build do
  ship_license "https://github.com/jplana/python-etcd/blob/master/LICENSE.txt"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" python-etcd==#{version}"
end
