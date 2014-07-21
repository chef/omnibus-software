name "snakebite_1_x"
default_version "1.3.9"

dependency "python"
dependency "pip"

build do
  command "#{install_dir}/embedded/bin/pip install -I --build #{project_dir} --install-option=\"--install-scripts=#{install_dir}/bin\" snakebite==#{version}"
  command "mv #{install_dir}/embedded/lib/site-packages/snakebite #{install_dir}/embedded/lib/python2.7/site-packages/snakebite_1_x"
end
