name "pysnmp"
default_version "4.2.5"

dependency "python"
dependency "pip"
dependency "pysnmp-mibs"

build do
  ship_license "https://gist.githubusercontent.com/remh/519324dc1b69f7488239/raw/2bbf2888194fef8ae75651e551b61f90cb49c482/pysnmp.license"
  if ohai['platform'] == 'windows'
    pip "install -I --install-option=\"--install-scripts="\
             "#{windows_safe_path(install_dir)}\\bin\" #{name}==#{version}"
  else
    pip "install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  end
end
