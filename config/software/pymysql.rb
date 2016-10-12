name "pymysql"
default_version "0.6.6"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/PyMySQL/PyMySQL/master/LICENSE"
  command "#{install_dir}/embedded/bin/pip install --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end
