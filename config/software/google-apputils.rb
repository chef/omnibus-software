#
# NOTICE : google-apputils has been added as a snakebite dependency. It may look
# useless in the first place since supervisor is installed using pip/setup.py
# which are supposed to install dependencies as well but there is a certificate
# issue on OSX when using setup.py. Therefore we have to make sure our
# dependency is installed before supervisor gets setup.
#
name "google-apputils"
default_version "0.4.2"

dependency "python"
dependency "pip"

# Required by snakebite

build do
    pip "install #{name}==#{version}"
end
