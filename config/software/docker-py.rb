name "docker-py"
default_version "1.10.6"

dependency "python"
dependency "pip"

build do
  license "Apache-2.0"
  # Don't use --install-option to specify the scripts path, as this disables wheels, and one of the
  # docker-py deps (pywin32) can only be installed with a wheel
  pip "install #{name}==#{version}"
end
