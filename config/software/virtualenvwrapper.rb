name "virtualenvwrapper"
default_version "4.1.1"

dependency "python"
dependency "pip"
dependency "virtualenv"

build do
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
