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
  wheel_name = "pycurl-7.43.0-cp27-none-win_amd64.whl"
  wheel_md5 = '66c232b0da1e8314cf3794c5644ff49f'

  source :url => "https://s3.amazonaws.com/dd-agent-omnibus/#{wheel_name}",
         :md5 => wheel_md5

  relative_path "pycurl-#{version}"

  build do
    pip "install #{wheel_name}"

    # Delete these lines as soon as we have upgraded to pycurl > 7.43.0
    # This is a custom built pycurl
    python_lib_path = File.join(install_dir, 'embedded', 'Lib', 'site-packages')
    command 'powershell.exe -Command wget -outfile pycurl.pyd https://s3.amazonaws.com/dd-agent-omnibus/pycurl.pyd'
    pycurl_sha256 = '47 c6 b1 ca aa 11 a5 a1 cf 39 38 a1 0b f3 2a 21 e8 72 3c 16 ec bb 4a f8 b8 20 87 4d be 29 ba 31'
    command "CertUtil -hashfile pycurl.pyd SHA256 | grep '#{pycurl_sha256}' && mv pycurl.pyd #{python_lib_path}"

    command 'powershell.exe -Command wget -outfile msvcr110.dll https://s3.amazonaws.com/dd-agent-omnibus/msvcr110.dll'
    vcruntime_sha256 = '0c bb d9 69 1f 08 43 4d a3 61 78 74 f9 9c 6d d8 75 38 cb d6 5b 5d 8b c3 9f ce 37 8d 4e d2 9e ed'
    command "CertUtil -hashfile msvcr110.dll SHA256 | grep '#{vcruntime_sha256}' && mv msvcr110.dll #{python_lib_path}"
  end
end
