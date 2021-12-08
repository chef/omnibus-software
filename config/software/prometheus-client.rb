name "prometheus-client"
default_version "0.1.0"

dependency "python"
dependency "pip"

build do
  license "Apache-2.0"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
