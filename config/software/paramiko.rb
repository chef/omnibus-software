name "paramiko"
default_version "2.1.2"

dependency "python"
dependency "pip"
dependency "cryptography"
dependency "pyasn1"

build do
  ship_license "https://raw.githubusercontent.com/paramiko/paramiko/master/LICENSE"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
