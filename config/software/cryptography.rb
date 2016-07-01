name "cryptography"
default_version "1.3.2"

dependency "python"
dependency "pip"
dependency "openssl-windows"

build do
  ship_license "https://github.com/pyca/cryptography/blob/master/LICENSE.APACHE"
  pip "install -I cryptography==#{version}"
end
