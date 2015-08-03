name "snakebite"
default_version "1.3.11"

dependency "python"
dependency "pip"
dependency "google-apputils"

build do
  ship_license "https://raw.githubusercontent.com/spotify/snakebite/master/LICENSE"
  if ohai['platform'] == 'windows'
    pip_call "install --install-option=\"--install-scripts='"\
             "#{windows_safe_path(install_dir)}\\bin'\" #{name}==#{version}"
  else
    pip_call "install --install-option=\"--install-scripts=#{install_dir}/bin\" "\
             "#{name}==#{version}"
  end
end
