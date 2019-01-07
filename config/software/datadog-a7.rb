name "datadog-a7"
default_version "0.0.3"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/DataDog/datadog-checks-shared/master/LICENSE"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
