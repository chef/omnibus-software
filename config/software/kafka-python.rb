name "kafka-python"
default_version "1.3.1"


dependency "python"
dependency "pip"

build do
  ship_license "Apachev2"
  pip "install --install-option=\"--install-scripts=#{windows_safe_path(install_dir)}/bin\" #{name}==#{version}"
end
