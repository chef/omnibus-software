name "ntplib"
default_version "0.3.2"

dependency "python"
dependency "pip"

build do
  command "rm -rf /var/cache/omnibus/src/ntplib"
  command "#{install_dir}/embedded/bin/pip install --force-reinstall -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end
