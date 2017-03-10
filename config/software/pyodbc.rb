name "pyodbc"
default_version "4.0.13"

dependency "python"
dependency "pip"
# Requires additional dep on Linux: unixODBC

build do
  ship_license "https://raw.githubusercontent.com/mkleehammer/pyodbc/master/LICENSE.txt"
  pip "install --install-option="\
      "\"--install-scripts=#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
