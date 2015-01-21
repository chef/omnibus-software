name "psutil"
default_version "2.1.3"

dependency "python"
dependency "pip"

build do
  license "https://raw.githubusercontent.com/giampaolo/psutil/master/LICENSE"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end