name "boto"
default_version "2.46.1"
dependency "python"
dependency "pip"

build do
  license "MIT"
  license_file "https://raw.githubusercontent.com/boto/boto/develop/LICENSE"
  pip "install #{name}==#{version}"
end
