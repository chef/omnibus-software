name "pyside"

default_version "1.2.2"

dependency "python"

if ohai["platform"] == "mac_os_x"

  dependency "cmake"
  dependency "qt"

  source url: "https://pypi.python.org/packages/source/P/PySide/PySide-#{version}.tar.gz",
         sha256: "53129fd85e133ef630144c0598d25c451eab72019cdcb1012f2aec773a3f25be"

  relative_path "PySide-#{version}"

  env = {
    "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}",
  }

  build do
    command "#{install_dir}/embedded/bin/python setup.py install "\
            "--record #{install_dir}/embedded/pyside-files.txt", env: env
  end

elsif ohai["platform"] == "windows"
  dependency "pip"
  build do
    pip "install PySide==#{version}"
  end
end
