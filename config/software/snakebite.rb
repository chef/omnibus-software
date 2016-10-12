name "snakebite"
default_version "1.3.11"

dependency "python"
dependency "pip"
dependency "google-apputils"

build do
  ship_license "https://raw.githubusercontent.com/spotify/snakebite/master/LICENSE"
  command "#{install_dir}/embedded/bin/pip install --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end
