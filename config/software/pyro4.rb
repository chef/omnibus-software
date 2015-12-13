name "pyro4"
default_version "4.35"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/irmen/Pyro4/master/LICENSE"
  if ohai['platform'] == 'windows'
    pip "install --install-option=\"--install-scripts='"\
             "#{windows_safe_path(install_dir)}/bin'\" Pyro4==#{version}"
  else
    pip "install --install-option=\"--install-scripts=#{install_dir}/bin\" "\
             "Pyro4==#{version}"
  end
end
