name "kazoo"
default_version "2.2.1"

dependency "python"
dependency "pip"

build do
  ship_license "Apachev2"
  if ohai['platform'] == 'windows'
    pip "install --install-option=\"--install-scripts='#{windows_safe_path(install_dir)}\\bin'\" #{name}==#{version}"
  else
    pip "install --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  end
end
