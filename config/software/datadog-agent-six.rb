name "datadog-agent-six"
default_version "0.1.0"

dependency "python2"
dependency "python3"

license "Apache"
license_file "LICENSE"
skip_transitive_dependency_licensing true

source :url => "https://github.com/DataDog/datadog-agent-six/archive/v#{version}.tar.gz",
       :sha256 => "ec6a63b38d99b6159a28f05c6c29c653a767c67323a58976bc2e05913b7b8733",
       :extract => :seven_zip

relative_path "datadog-agent-six-#{version}"

if ohai["platform"] != "windows"
  build do
    env = {
        "Python2_ROOT_DIR" => "#{install_dir}/embedded",
        "Python3_ROOT_DIR" => "#{install_dir}/embedded",
        "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib",
    }

    command "cmake -DCMAKE_INSTALL_PREFIX:PATH=#{install_dir}/embedded .", :env => env
    command "make -j #{workers}"
    command "make install"
  end
else
 build do
    env = {
        "Python2_ROOT_DIR" => "#{windows_safe_path(python_2_embedded)}",
        "Python3_ROOT_DIR" => "#{windows_safe_path(python_3_embedded)}",
    }

    command "cmake -G \"Unix Makefiles\" .", :env => env
    command "make -j #{workers}"
    command "make install"
  end
end
