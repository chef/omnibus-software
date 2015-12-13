name "boto"
default_version "2.39.0"
dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/boto/boto/develop/LICENSE"
  if ohai['platform'] == 'windows'
    pip "install --install-option=\"--install-scripts='#{windows_safe_path(install_dir)}/bin'\" #{name}==#{version}"
  else
    pip "install --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  end
end
