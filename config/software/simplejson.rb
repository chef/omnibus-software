name "simplejson"
default_version "3.6.5"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/simplejson/simplejson/master/LICENSE.txt"
  if ohai['platform'] == 'windows'
    pip "install --install-option=\"--install-scripts='"\
             "#{windows_safe_path(install_dir)}\\bin'\" #{name}==#{version}"
  else
    pip "install --install-option=\"--install-scripts=#{install_dir}/bin\" "\
             "#{name}==#{version}"
  end
end
