name "beautifulsoup4"
default_version "4.5.1"

dependency "python"
dependency "pip"

build do
  ship_license "http://bazaar.launchpad.net/~leonardr/beautifulsoup/bs4/download/head:/copying-20110228012957-7ptf6yxua0sj3vhn-1/LICENSE"
  pip "install --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end
