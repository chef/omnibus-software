name "boto"
default_version "2.39.0"
dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/boto/boto/develop/LICENSE"
  pip "install #{name}==#{version}"
end
