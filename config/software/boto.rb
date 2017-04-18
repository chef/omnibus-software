name "boto"
default_version "2.46.1"
dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/boto/boto/develop/LICENSE"
  pip "install #{name}==#{version}"
end
