# Unless explicitly stated otherwise all files in this repository are licensed
# under the Apache License Version 2.0.
# This product includes software developed at Datadog (https:#www.datadoghq.com/).
# Copyright 2018 Datadog, Inc.

name "datadog-pip"

dependency "pip"

flags = ""
if ohai["kernel"]["machine"].start_with?("arm", "aarch")
  # installing the pip dependencies on armv7 makes it build the `cffi` python package
  # there is no pre-built ARM wheel of that package, and building it from source requires libffi to be installed
  dependency "libffi"
  # --no-buid-isolation is to fix: `No sources permitted for cffi` when pip is building it from source
  # see https://github.com/pypa/pip/issues/5171
  flags = "--no-build-isolation"
end

source git: "https://github.com/DataDog/pip.git"

relative_path "pip"

pip_version = ENV["PIP_VERSION"]
if pip_version.nil? || pip_version.empty?
  pip_version = "trishankatdatadog/18.1.tuf-in-toto"
end
default_version pip_version

build do
  # NOTE: the [tuf-in-toto] notation used for the pip commands below is to
  # enforce the installation of the `extras_require` defined in the setup.py.
  # (http://setuptools.readthedocs.io/en/latest/setuptools.html#declaring-extras-optional-features-with-their-own-dependencies)
  if ohai["platform"] == "windows"
    python_bin = "\"#{windows_safe_path(install_dir)}\\embedded\\python.exe\""
    command("#{python_bin} -m pip install --disable-pip-version-check --no-cache --upgrade #{windows_safe_path(project_dir)}\\[tuf-in-toto]")
  else
    build_env = {
      "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
      "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}",
    }
    pip "install #{flags} --disable-pip-version-check --no-cache --upgrade #{project_dir}/[tuf-in-toto]", :env => build_env
  end

end
