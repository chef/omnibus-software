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
  version '7.43.0'
  # if ohai['kernel']['machine'] == 'x86_64'
  #   wheel_name = "pycurl-7.43.0-cp27-none-win_amd64.whl"
  #   wheel_md5 = '66c232b0da1e8314cf3794c5644ff49f'
  # else
  wheel_name = "pycurl-7.43.0-cp27-none-win32.whl"
  wheel_md5 = '5d5a5c540c2d79d7321233b667c0d2a1'
  # end

  source :url => "https://s3.amazonaws.com/dd-agent-omnibus/#{wheel_name}",
         :md5 => wheel_md5

  relative_path "pycurl-#{version}"

  build do
    # God bless the maintainers of that website, god bless their families and children over
    # a thousand generation and, of course, Gog bless the United States of America
    pip "install #{wheel_name}"
  end
end
