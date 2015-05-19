name "meld3"
default_version "0.6.7"

dependency "python"
dependency "pip"

build do
  command "#{install_dir}/embedded/bin/pip install -I #{name}==#{version}"
end
