name "cryptography"
default_version "2.1.4"

dependency "python"
dependency "pip"

dependency "libffi" # indirectly through the `cffi` python lib cryptography depends on
dependency "openssl"
dependency "pyasn1"

build do
  ship_license "https://github.com/pyca/cryptography/blob/master/LICENSE.APACHE"
  pip "install cryptography==#{version}"
end
