name "uuid"
default_version "1.30"

dependency "python"
dependency "pip"

build do
  license "Python-2.0"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
