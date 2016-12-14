name "httplib2"
default_version "0.9"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/jcgregorio/httplib2/master/LICENSE"
    pip "install --install-option=\"--install-scripts=#{windows_safe_path(install_dir)}/bin\" #{name}==#{version}"
end
