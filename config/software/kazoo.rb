name "kazoo"
default_version "2.6.0"

dependency "python"
dependency "pip"

build do
  license "Apache-2.0"
  pip "install --install-option=\"--install-scripts=#{windows_safe_path(install_dir)}/bin\" #{name}==#{version}"
end
