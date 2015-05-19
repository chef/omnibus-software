name "supervisor"
default_version "3.1.3"

dependency "python"
dependency "pip"

if ohai['platform_family'] == 'mac_os_x'
  source :url => "https://github.com/Supervisor/supervisor/archive/#{version}.tar.gz",
         :md5 => '073f1912e8bfe5bf89e84b96495df62e'

  relative_path "supervisor-#{version}"

  dependency "meld3"

  build do
    ship_license "https://raw.githubusercontent.com/Supervisor/supervisor/master/LICENSES.txt"
    command "#{install_dir}/embedded/bin/python setup.py install"
  end
else
  build do
    ship_license "https://raw.githubusercontent.com/Supervisor/supervisor/master/LICENSES.txt"
    command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  end
end
