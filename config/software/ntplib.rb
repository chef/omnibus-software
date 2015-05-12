name "ntplib"
default_version "0.3.2"

dependency "python"
dependency "pip"

build do
  ship_license "LGPLv3"
  ship_license "GPLv2"
  delete "/var/cache/omnibus/src/ntplib"
  command "#{install_dir}/embedded/bin/pip install --force-reinstall -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}", :cwd => "/tmp"
end
