name "asn1crypto"
default_version "0.21.0"

dependency "python"
dependency "pip"

build do
  license "MIT"
  license_file "https://github.com/wbond/asn1crypto/blob/master/LICENSE"
  pip "install asn1crypto==#{version}"
end
