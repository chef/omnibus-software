name "pycrypto"
default_version "2.6"

dependency "python"
dependency "pip"

build do
  command "#{install_dir}/embedded/bin/pip install -I #{name}==#{version}"
end