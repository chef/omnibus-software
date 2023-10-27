name "datadog-agent-six"
default_version "master"

dependency "python2"
dependency "python3"

license "Apache"
license_file "LICENSE"
skip_transitive_dependency_licensing true

source git: "git://github.com/DataDog/datadog-agent-six"

relative_path "datadog-agent-six-#{version}"

if ohai["platform"] != "windows"
  build do
    env = {
        "Python2_ROOT_DIR" => "#{install_dir}/embedded",
        "Python3_ROOT_DIR" => "#{install_dir}/embedded",
        "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib",
    }

    cmake_options = [
      "-DCMAKE_FIND_FRAMEWORK:STRING=NEVER",
    ]
    cmake(*cmake_options, env: env)
  end
else
  build do
    env = {
        "Python2_ROOT_DIR" => "#{windows_safe_path(python_2_embedded)}",
        "Python3_ROOT_DIR" => "#{windows_safe_path(python_3_embedded)}",
    }
    cmake env: env
  end
end
