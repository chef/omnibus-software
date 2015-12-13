name "virtualenvwrapper"
default_version "4.1.1"

dependency "python"
dependency "pip"
dependency "virtualenv"

build do
  if ohai['platform'] == 'windows'
    pip "install -I --install-option=\"--install-scripts='"\
             "#{windows_safe_path(install_dir)}\\bin'\" #{name}==#{version}"
  else
    pip "install -I --install-option=\"--install-scripts=#{install_dir}/bin\" "\
             "#{name}==#{version}"
  end
end
