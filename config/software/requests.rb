name "requests"
default_version "2.21.0"

dependency "python"
dependency "pip"
dependency "pyopenssl"

build do
  license "Apache-2.0"
  license_file "https://raw.githubusercontent.com/kennethreitz/requests/master/LICENSE"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
