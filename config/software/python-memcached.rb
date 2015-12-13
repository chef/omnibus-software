name "python-memcached"
default_version "1.53"

dependency "python"
dependency "pip"

build do
  ship_license "PSFL"
  if ohai['platform'] == 'windows'
    pip "install --install-option=\"--install-scripts='"\
             "#{windows_safe_path(install_dir)}/bin'\" #{name}==#{version}"
  else
    pip "install --install-option=\"--install-scripts=#{install_dir}/bin\" "\
             "#{name}==#{version}"
  end
end
