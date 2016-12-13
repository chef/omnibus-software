name "cryptography"
default_version "1.6"

dependency "python"
dependency "pip"

if ohai['platform'] == 'windows'
  dependency "openssl-windows"
else
  dependency "openssl"
end

build do
  ship_license "https://github.com/pyca/cryptography/blob/master/LICENSE.APACHE"
  pip "install cryptography==#{version}"
end
