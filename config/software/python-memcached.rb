name "python-memcached"
default_version "1.53"

dependency "python"
dependency "pip"

build do
  ship_license "PSFL"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
