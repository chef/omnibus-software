name "cryptography"
default_version "1.6"

dependency "python"
dependency "pip"
dependency "openssl-windows"

build do
  ship_license "https://github.com/pyca/cryptography/blob/master/LICENSE.APACHE"
  pip "install cryptography==#{version}"
end
