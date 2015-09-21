#!/usr/bin/env ruby
# encoding: utf-8

name "pycurl"
default_version "7.43.0"

dependency "python"
dependency "pip"

if ohai['platform'] != "windows"
  dependency "curl"
  dependency "gdbm" if (ohai['platform'] == "mac_os_x" or ohai['platform'] == "freebsd" or ohai['platform'] == "aix")
  dependency "libgcc" if (ohai['platform'] == "solaris2" and Omnibus.config.solaris_compiler == "gcc")

  build do
    ship_license "https://raw.githubusercontent.com/pycurl/pycurl/master/COPYING-MIT"
    build_env = {
      "PATH" => "/#{install_dir}/embedded/bin:#{ENV['PATH']}",
      "ARCHFLAGS" => "-arch x86_64"
    }
    command "#{install_dir}/embedded/bin/pip install #{name}==#{version}", :env => build_env
  end
else
  if ohai['kernel']['machine'] == 'x86_64'
    wheel_name = "pycurl-7.19.5.1-cp27-none-win_amd64.whl"
    wheel_md5 = 'ed9b98964a07ce5a5de309d3a8d983bb'
  else
    wheel_name = "pycurl-7.19.5.1-cp27‑none-win32.whl"
    wheel_md5 = 'ed9b98964a07ce5a5de309d3a8d983bb'
  end

  source :url => "http://www.lfd.uci.edu/~gohlke/pythonlibs/3i673h27/#{wheel_name}",
         :md5 => wheel_md5

  relative_path "pycurl-#{version}"

  build do
    # God bless the maintainers of that website, god bless their families and children over
    # a thousand generation and, of course, Gog bless the United States of America
    pip_call "install #{wheel_name}"
  end
end
