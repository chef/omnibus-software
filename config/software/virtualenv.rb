name "virtualenv"
default_version "1.10.1"

dependency "python"
dependency "pip"

build do
  if ohai['platform'] == 'windows'
    pip "install -I --install-option=\"--install-scripts='"\
             "#{windows_safe_path(install_dir)}\\bin'\" #{name}==#{version}"
  else
    pip "install -I --install-option=\"--install-scripts=#{install_dir}/bin\" "\
             "#{name}==#{version}"
  end
end
