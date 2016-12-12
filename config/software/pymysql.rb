name "pymysql"
default_version "0.6.6"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/PyMySQL/PyMySQL/master/LICENSE"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
