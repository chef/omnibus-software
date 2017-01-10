name "pg8000"
default_version "1.10.1"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/mfenniak/pg8000/master/LICENSE"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
