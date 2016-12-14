name "boto"
default_version "2.39.0"
dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/boto/boto/develop/LICENSE"
  pip "install --install-option=\"--install-scripts='#{windows_safe_path(install_dir)}/bin'\" #{name}==#{version}"
end
