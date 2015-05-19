name 'pyside'

default_version '1.2.2'

dependency 'python'
dependency 'cmake'
dependency 'qt'

source :url => "https://pypi.python.org/packages/source/P/PySide/PySide-#{version}.tar.gz",
       :md5 => 'c45bc400c8a86d6b35f34c29e379e44d'

relative_path "PySide-#{version}"

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}

build do
  command "#{install_dir}/embedded/bin/python setup.py install", :env => env
end
