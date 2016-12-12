name "paramiko"
default_version "1.15.2"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/paramiko/paramiko/master/LICENSE"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
