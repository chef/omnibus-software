name "uuid"
default_version "1.30"

dependency "python"
dependency "pip"

build do
  ship_license "PSFL"
  pip "install -I --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
