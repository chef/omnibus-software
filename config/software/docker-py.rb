name "docker-py"
default_version "1.8.1"

dependency "python"
dependency "pip"

build do
  ship_license "Apachev2"
  # We don't use docker-py on Windows yet but it will come one day :)
  if ohai['platform'] == 'windows'
    pip_call "install --force-reinstall --install-option=\"--install-scripts='#{windows_safe_path(install_dir)}\\bin'\" #{name}==#{version}"
  else
    pip_call "install --force-reinstall --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}", :cwd => "/tmp"
  end
end
