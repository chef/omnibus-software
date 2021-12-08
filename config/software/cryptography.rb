name "cryptography"
default_version "2.8"

dependency "python"
dependency "pip"

dependency "libffi" # indirectly through the `cffi` python lib cryptography depends on
dependency "openssl"
dependency "asn1crypto"

build do
  license "Apache-2.0"
  license_file "https://github.com/pyca/cryptography/blob/master/LICENSE.APACHE"
  pip "install cryptography==#{version}"
end
