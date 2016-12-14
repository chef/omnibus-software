name "virtualenv"
default_version "1.10.1"

dependency "python"
dependency "pip"

build do
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
