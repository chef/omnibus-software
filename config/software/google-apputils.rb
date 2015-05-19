name "google-apputils"
default_version "0.4.2"

dependency "python"
dependency "pip"

build do
  command "#{install_dir}/embedded/bin/pip install -I #{name}==#{version}"
end
