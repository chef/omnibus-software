name "docker-py"
default_version "1.10.6"

dependency "python"
dependency "pip"

build do
  ship_license "Apachev2"
  # Don't use --install-option to specify the scripts path, as this disables wheels, and one of the
  # docker-py deps (pywin32) can only be installed with a wheel
  pip "install #{name}==#{version}"
end
