name "simplejson"
default_version "3.6.5"

dependency "python"
dependency "pip"

build do
  license "MIT"
  license_file "https://raw.githubusercontent.com/simplejson/simplejson/master/LICENSE.txt"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
