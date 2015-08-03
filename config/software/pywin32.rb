name 'pywin32'
default_version '219'

if ohai['kernel']['machine'] == 'x86_64'
  wheel_name = "pywin32-#{version}-cp27-none-win_amd64.whl"
  wheel_md5 = '79047dc39b6b0c7b45641730ef4212fe'
else
  wheel_name = "pywin32‑#{version}‑cp27‑none‑win32.whl"
  wheel_md5 = '79047dc39b6b0c7b45641730ef4212fe'
end

source :url => "http://www.lfd.uci.edu/~gohlke/pythonlibs/3i673h27/#{wheel_name}",
       :md5 => wheel_md5

dependency "python"
dependency "pip"

build do
    relative_path "pywin32-#{version}"
    # Switch on the architecture
    pip_call "install pywin32-#{version}-cp27-none-win_amd64.whl "\
             "--install-option=\"--prefix=#{windows_safe_path(install_dir)}\\embedded\""
end
