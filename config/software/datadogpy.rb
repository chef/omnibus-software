name "datadogpy"
default_version "0.10.0"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/DataDog/datadogpy/master/LICENSE"
  # We use `pip install` w/o the `-I` option here because we don't want pip to ignore the deps that have
  # already been installed (for instance `requests`), as it could make pip potentially install a different version of the the dep
  command "#{install_dir}/embedded/bin/pip install --install-option=\"--install-scripts=#{install_dir}/bin\" datadog==#{version}"
end
