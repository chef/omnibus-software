name 'guidata'

default_version '1.6.1'

dependency 'pyside'

source :url => "https://guidata.googlecode.com/files/guidata-#{version}.zip",
	   :md5 => '47d625f998b5092ba797c8657979aa94'
       # :sha1 => 'abc80daf473562eb6132c2245d8108afe6451645'

relative_path "guidata-#{version}"

build do
  patch :source => 'fix_blocking_import.patch'
  patch :source => 'remove_default_image_path.patch' if ohai['platform_family'] == 'mac_os_x'
  if ohai['platform'] == 'windows'
    env = {
      "PATH" => "#{windows_safe_path(install_dir)}\\embedded\\bin:#{ENV["PATH"]}"
    }
    command "SET LC_ALL=\"C\""
    command "SET PATH=\"#{env['PATH']}\""
    command "\"#{windows_safe_path(install_dir)}\\embedded\\python\" setup.py install "\
            "--record \"#{windows_safe_path(install_dir)}\\embedded\\guidata-files.txt\""
  else
    env = {
      "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}"
    }
    command "#{install_dir}/embedded/bin/python setup.py install "\
            "--record #{install_dir}/embedded/guidata-files.txt", :env => env
  end
end
