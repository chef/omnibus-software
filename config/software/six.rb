name "six"
default_version "1.12.0"

dependency "pip"

build do
  license "MIT"
  # Note (2021/11/12): link is dead
  # license_file "https://bitbucket.org/gutworth/six/raw/e5218c3f66a2614acb7572204a27e2b508682168/LICENSE"
  pip "install #{name}==#{version}"
end
