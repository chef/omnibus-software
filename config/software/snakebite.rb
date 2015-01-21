name "snakebite"
default_version "1.3.9"

dependency "python"
dependency "pip"

build do
  license "https://raw.githubusercontent.com/spotify/snakebite/master/LICENSE"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end