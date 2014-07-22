name "pycurl"
default_version "7.19.3.1"

dependency "python"
dependency "pip"
dependency "curl"
dependency "gdbm" if (platform == "mac_os_x" or platform == "freebsd" or platform == "aix")
dependency "libgcc" if (platform == "solaris2" and Omnibus.config.solaris_compiler == "gcc")

build do
  build_env = {
    "PATH" => "/#{install_dir}/embedded/bin:#{ENV['PATH']}"
  }
  command "#{install_dir}/embedded/bin/pip install -I #{name}==#{version}", :env => build_env
end
