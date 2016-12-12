name "futures"
default_version "2.2.0"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/agronholm/pythonfutures/master/LICENSE"
  pip "install --install-option=\"--install-scripts=#{windows_safe_path(install_dir)}/bin\" #{name}==#{version}"
end
