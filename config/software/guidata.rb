name "guidata"

default_version "1.6.1"

dependency "pyside"

source url: "https://github.com/PierreRaybaut/guidata/archive/v#{version}.zip",
       sha256: "9537f78359251814cb85f8610bbd7f3d2aa1050348c0c9d4cdc34ad2dedfdea4"

relative_path "guidata-#{version}"

build do
  patch source: "fix_blocking_import.patch"
  patch source: "remove_default_image_path.patch" if ohai["platform_family"] == "mac_os_x"
  if ohai["platform"] == "windows"
    env = {
      "PATH" => "#{windows_safe_path(install_dir)}\\embedded\\bin:#{ENV["PATH"]}",
    }
    command "SET LC_ALL=\"C\""
    command "SET PATH=\"#{env["PATH"]}\""
    command "\"#{windows_safe_path(install_dir)}\\embedded\\python\" setup.py install "\
            "--record \"#{windows_safe_path(install_dir)}\\embedded\\guidata-files.txt\""
  else
    env = {
      "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}",
    }
    command "#{install_dir}/embedded/bin/python setup.py install "\
            "--record #{install_dir}/embedded/guidata-files.txt", env: env
  end
end
