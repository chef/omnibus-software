name "dnspython"
default_version "1.12.0"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/rthalley/dnspython/v1.12.0/LICENSE"
  pip "install --install-option=\"--install-scripts=#{install_dir}/bin\" dnspython==#{version}"
end
