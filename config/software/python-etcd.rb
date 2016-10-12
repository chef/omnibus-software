name "python-etcd"
default_version "0.4.2"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/jplana/python-etcd/master/LICENSE.txt"
  # pin the `urllib3` subdependency to 1.16 to avoid memory bloat of 1.17 (see commit for details)
  command "#{install_dir}/embedded/bin/pip install --install-option=\"--install-scripts=#{install_dir}/bin\" urllib3==1.16 python-etcd==#{version}"
end
