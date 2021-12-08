name "ntplib"
default_version "0.3.4"

dependency "python"
dependency "pip"

build do
  license "MIT"
  if ohai["platform"] == "windows"
    pip "install "\
        "#{name}==#{version}"
  else
    pip "install "\
        "#{name}==#{version}", cwd: "/tmp"
  end
end
