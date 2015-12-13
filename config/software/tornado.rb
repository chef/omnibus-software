name "tornado"
default_version "3.2.2"

dependency "python"
dependency "pip"
dependency "pycurl"
dependency "futures"

build do
  ship_license "https://raw.githubusercontent.com/tornadoweb/tornado/master/LICENSE"
  if ohai['platform'] == 'windows'
    pip "install -I --install-option=\"--install-scripts='"\
             "#{windows_safe_path(install_dir)}/bin'\" #{name}==#{version}"
  else
    pip "install -I --install-option=\"--install-scripts=#{install_dir}/bin\" "\
             "#{name}==#{version}"
  end
end
