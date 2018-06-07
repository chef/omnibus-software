# Unless explicitly stated otherwise all files in this repository are licensed
# under the Apache License Version 2.0.
# This product includes software developed at Datadog (https:#www.datadoghq.com/).
# Copyright 2018 Datadog, Inc.

name "datadog-pip"

dependency "pip"

source git: "https://github.com/DataDog/pip.git"

relative_path "pip"

pip_version = ENV["PIP_VERSION"]
if pip_version.nil? || pip_version.empty?
  pip_version = "trishankatdatadog/10.0.1.tuf"
end
default_version pip_version

# Phase 1 stuff - unneeded currently
# substitution_layer_url = "https://github.com/in-toto/in-toto/archive/add-substitution-layer.zip"

build do
  # NOTE: the [tuf] notation used for the pip commands below is to enforce the installation
  # of the `extras_require` defined in the setup.py.
  # (http://setuptools.readthedocs.io/en/latest/setuptools.html#declaring-extras-optional-features-with-their-own-dependencies)
  if ohai["platform"] == "windows"
    python_bin = "\"#{windows_safe_path(install_dir)}\\embedded\\python.exe\""
    command("#{python_bin} -m pip install --disable-pip-version-check --no-cache --upgrade #{windows_safe_path(project_dir)}\\[tuf]")
  else
    pip "install --disable-pip-version-check --no-cache --upgrade #{project_dir}/[tuf]"
  end

  # Phase 1 stuff - unneeded currently
  # pip "install --disable-pip-version-check --no-cache --upgrade #{substitution_layer_url}"
end
