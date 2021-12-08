name "tornado"
default_version "3.2.2"

dependency "python"
dependency "pip"
dependency "pycurl"
dependency "futures"

build do
  license "Apache-2.0"
  license_file "https://raw.githubusercontent.com/tornadoweb/tornado/master/LICENSE"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
