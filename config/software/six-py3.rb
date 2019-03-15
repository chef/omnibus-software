name "six-py3"
default_version "1.11.0"

#dependency "pip-py2"

build do
  ship_license "https://bitbucket.org/gutworth/six/raw/e5218c3f66a2614acb7572204a27e2b508682168/LICENSE"
  py3pip "install #{name}==#{version}"
end
