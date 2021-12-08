name "datadog-a7-py2"
default_version "0.0.5"

dependency "pip-py2"

build do
  license "BSD-3-Clause"
  license_file "https://raw.githubusercontent.com/DataDog/datadog-checks-shared/master/LICENSE"
  py2pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version} "\
      "configparser==3.5.0" # this pins a dependency of pylint->datadog-a7, later versions (up to v3.7.1) are broken.
                            # TODO: all deps should be pinned.
end
