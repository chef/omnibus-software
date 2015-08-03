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
  if ohai['platform'] == 'windows'
    command "\"#{install_dir}/embedded/python.exe\" setup.py install "\
            "--record \"#{windows_safe_path(install_dir)}\\embedded\\spyderlib-files.txt\"",
            :env => env
  else
    command "#{install_dir}/embedded/bin/python setup.py install "\
            "--record #{install_dir}/embedded/spyderlib-files.txt", :env => env
  end
end
