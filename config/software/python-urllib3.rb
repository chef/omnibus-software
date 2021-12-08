name "urllib3"
default_version "1.24.3"

dependency "python"
dependency "pip"

build do
  license "MIT"
  license_file "https://raw.githubusercontent.com/urllib3/urllib3/master/LICENSE.txt"
  pip "install --install-option=\"--install-scripts=#{windows_safe_path(install_dir)}/bin\" #{name}==#{version}"
end
