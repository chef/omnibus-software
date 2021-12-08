name "six-py2"
default_version "1.11.0"

dependency "pip-py2"

build do
  license "MIT"
  # Note (2021/11/12): link is dead
  # license_file "https://bitbucket.org/gutworth/six/raw/e5218c3f66a2614acb7572204a27e2b508682168/LICENSE"
  py2pip "install six==#{version}"
end
