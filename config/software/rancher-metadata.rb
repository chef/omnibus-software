name "rancher-metadata"
default_version "0.17.15"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/m4ce/rancher-metadata-python/master/LICENSE.txt"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
