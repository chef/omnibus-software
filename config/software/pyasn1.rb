name "pyasn1"
default_version "0.2.3"

dependency "python"
dependency "pip"

build do
  license "BSD-2-Clause"
  license_file "https://raw.githubusercontent.com/etingof/pyasn1/master/LICENSE.rst"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
