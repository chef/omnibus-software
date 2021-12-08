name "datadogpy"
default_version "0.14.0"

dependency "python"
dependency "pip"

build do
  license "BSD-3-Clause"
  license_file "https://raw.githubusercontent.com/DataDog/datadogpy/master/LICENSE"
  # We use `pip install` w/o the `-I` option here because we don't want pip to ignore the deps that have
  # already been installed (for instance `requests`), as it could make pip potentially install a different version of the the dep
  pip "install --install-option=\"--install-scripts=#{install_dir}/bin\" datadog==#{version}"
end
