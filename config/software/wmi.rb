name "wmi"
default_version "1.4.9"

dependency "python"
dependency "pip"

build do
  license "MIT"
  pip "install #{name}==#{version}"
end
