name "docker-py"
default_version "1.3.1"

dependency "python"
dependency "pip"

build do
  command "#{install_dir}/embedded/bin/pip install --force-reinstall -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}", :cwd => "/tmp"
end
