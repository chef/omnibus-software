name "pyasn1"
default_version "0.1.9"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/etingof/pyasn1/master/LICENSE.rst"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
