name "spyderlib"

default_version "2.3.2"

dependency "guidata"

source url: "https://github.com/spyder-ide/spyder/archive/v#{version}.tar.gz",
       sha256: "a7fb7ba3fc3e0b9ddeb09d91a250d8e303f6f0438101db09b025133fe2dc267d",
       extract: :seven_zip

relative_path "spyder-#{version}"

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}",
}

build do
  if ohai["platform"] == "windows"
    command "\"#{install_dir}/embedded/python.exe\" setup.py install "\
            "--record \"#{windows_safe_path(install_dir)}\\embedded\\spyderlib-files.txt\"",
      env: env
  else
    command "#{install_dir}/embedded/bin/python setup.py install "\
            "--record #{install_dir}/embedded/spyderlib-files.txt", env: env
  end
end
