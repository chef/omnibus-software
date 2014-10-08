name "pycurl"
default_version "7.19.5"

dependency "python"
dependency "pip"
dependency "curl"
dependency "gdbm" if (Ohai['platform'] == "mac_os_x" or Ohai['platform'] == "freebsd" or Ohai['platform'] == "aix")
dependency "libgcc" if (Ohai['platform'] == "solaris2" and Omnibus.config.solaris_compiler == "gcc")

build do
  build_env = {
    "PATH" => "/#{install_dir}/embedded/bin:#{ENV['PATH']}"
  }
  command "#{install_dir}/embedded/bin/pip install -I #{name}==#{version}", :env => build_env
end