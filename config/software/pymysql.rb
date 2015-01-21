name "pymysql"
default_version "0.6.2"

dependency "python"
dependency "pip"

build do
  license "https://raw.githubusercontent.com/PyMySQL/PyMySQL/master/LICENSE"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end