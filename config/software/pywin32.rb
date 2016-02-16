name 'pywin32'
default_version '219'

if ohai['kernel']['machine'] == 'x86_64'
  wheel_name = "pywin32-#{version}-cp27-none-win_amd64.whl"
  wheel_md5 = '79047dc39b6b0c7b45641730ef4212fe'
else
  wheel_name = "pywin32‑#{version}‑cp27‑none‑win32.whl"
  wheel_md5 = '79047dc39b6b0c7b45641730ef4212fe'
end

source :url => "https://s3.amazonaws.com/dd-agent-omnibus/#{wheel_name}",
       :md5 => wheel_md5

dependency "python"
dependency "pip"

build do
    relative_path "pywin32-#{version}"
    # Switch on the architecture
    pip "install pywin32-#{version}-cp27-none-win_amd64.whl "\
             "--install-option=\"--prefix=#{windows_safe_path(install_dir)}\\embedded\""
    # Otherwise pywintypes doesn't work (found with Python 2.7.11)
    win32_lib_path = "#{windows_safe_path(install_dir)}\\embedded\\Lib\\site-packages\\win32"
    command "cp \"#{win32_lib_path}\\*27.dll\" \"#{win32_lib_path}\\lib\""
end
