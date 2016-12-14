#
# NOTICE : meld3 has been added as a supervisor dependency. It may look useless
# in the first place since supervisor is installed using pip/setup.py which are
# supposed to install dependencies as well but there is a certificate issue on
# OSX when using setup.py. Therefore we have to make sure our dependency is
# installed before supervisor gets setup.
#
name "meld3"
default_version "0.6.7"

dependency "python"
dependency "pip"

build do
  pip "install #{name}==#{version}"
end
