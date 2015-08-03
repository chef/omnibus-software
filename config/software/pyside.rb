name 'pyside'

default_version '1.2.2'

dependency 'python'

if ohai['platform'] == 'mac_os_x'

  dependency 'cmake'
  dependency 'qt'

  source :url => "https://pypi.python.org/packages/source/P/PySide/PySide-#{version}.tar.gz",
         :md5 => 'c45bc400c8a86d6b35f34c29e379e44d'

  relative_path "PySide-#{version}"

  env = {
    "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
  }

  build do
    command "#{install_dir}/embedded/bin/python setup.py install "\
            "--record #{install_dir}/embedded/pyside-files.txt", :env => env
  end

elsif ohai['platform'] == 'windows'
  dependency 'pip'
  build do
    pip_call "install -U PySide"
  end
end
