#!/usr/bin/env ruby
# encoding: utf-8

name "pycurl"
default_version "7.43.0.3"

dependency "python"
dependency "pip"

if ohai["platform"] != "windows"
  dependency "curl"
  dependency "gdbm" if ohai["platform"] == "mac_os_x" || ohai["platform"] == "freebsd" || ohai["platform"] == "aix"
  dependency "libgcc" if ohai["platform"] == "solaris2" && Omnibus.config.solaris_compiler == "gcc"

  build do
    license "MIT"
    license_file "https://raw.githubusercontent.com/pycurl/pycurl/master/COPYING-MIT"
    build_env = {
      "PATH" => "/#{install_dir}/embedded/bin:#{ENV["PATH"]}",
      "ARCHFLAGS" => "-arch x86_64",
    }
    command "#{install_dir}/embedded/bin/pip install #{name}==#{version}", env: build_env
  end
else
  version "7.43.0"
  wheel_name = "pycurl-7.43.0.2-cp27-cp27m-win_amd64.whl"
  wheel_sha256 = "dabc2f374858e635f029708a01aabae235bbff4406313768507908cc760a008a"

  # we use a hand-rolled binary pycurl wheel built against libcurl 7.64.1
  source url: "https://s3.amazonaws.com/dd-agent-omnibus/#{wheel_name}",
         sha256: wheel_sha256

  relative_path "pycurl-#{version}"

  build do
    pip "install #{wheel_name}"
  end
end
