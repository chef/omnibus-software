name "pysnmp-mibs"
default_version "0.1.4"

dependency "python"
dependency "pip"
dependency "setuptools"

build do
  ship_license "https://gist.githubusercontent.com/remh/519324dc1b69f7488239/raw/2bbf2888194fef8ae75651e551b61f90cb49c482/pysnmp.license"
  if ohai['platform'] == 'windows'
     pip_call "install --install-option="\
            "\"--install-scripts=#{windows_safe_path(install_dir)}\\bin\" "\
            "#{name}==#{version}"
  else
    pip_call "#{install_dir}/embedded/bin/pip install --install-option=\"--install-scripts="\
             "#{install_dir}/bin\" #{name}==#{version}"
  end
end

