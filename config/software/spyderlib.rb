name 'spyderlib'

default_version '2.3.2'

dependency 'guidata'

source :url => "https://github.com/spyder-ide/spyder/archive/v#{version}.tar.gz",
       :md5 => 'a67dfcc612b95ca9a627e30a28aebd37'

relative_path "spyder-#{version}"

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}

build do
  command "#{install_dir}/embedded/bin/python setup.py install", :env => env
end
