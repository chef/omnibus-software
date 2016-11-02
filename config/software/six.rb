name "six"
default_version "1.10.0"

dependency "python"
dependency "pip"

build do
  ship_license "https://bitbucket.org/gutworth/six/raw/e5218c3f66a2614acb7572204a27e2b508682168/LICENSE"
  command "#{install_dir}/embedded/bin/pip install #{name}==#{version}"
end