name "pyro4"
default_version "4.36"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/irmen/Pyro4/master/LICENSE"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "Pyro4==#{version}"
end
