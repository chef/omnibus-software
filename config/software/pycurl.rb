#!/usr/bin/env ruby
# encoding: utf-8

name "pycurl"
default_version "7.43.0"

dependency "python"
dependency "pip"

if ohai["platform"] != "windows"
  dependency "curl"
  dependency "gdbm" if ohai["platform"] == "mac_os_x" || ohai["platform"] == "freebsd" || ohai["platform"] == "aix"
  dependency "libgcc" if ohai["platform"] == "solaris2" && Omnibus.config.solaris_compiler == "gcc"

  build do
    ship_license "https://raw.githubusercontent.com/pycurl/pycurl/master/COPYING-MIT"
    build_env = {
      "PATH" => "/#{install_dir}/embedded/bin:#{ENV['PATH']}",
      "ARCHFLAGS" => "-arch x86_64",
    }
    command "#{install_dir}/embedded/bin/pip install #{name}==#{version}", :env => build_env
  end
else
  version "7.43.0"
  wheel_name = "pycurl-7.43.0-cp27-none-win_amd64.whl"
  wheel_md5 = "66c232b0da1e8314cf3794c5644ff49f"

  source :url => "https://s3.amazonaws.com/dd-agent-omnibus/#{wheel_name}",
         :md5 => wheel_md5

  relative_path "pycurl-#{version}"

  build do
    pip "install #{wheel_name}"

    # Delete these lines as soon as we have upgraded to pycurl > 7.43.0
    # This is a custom built pycurl
    python_lib_path = File.join(install_dir, "embedded", "Lib", "site-packages")
    command "powershell.exe -Command wget -outfile pycurl.pyd https://s3.amazonaws.com/dd-agent-omnibus/pycurl.pyd"
    pycurl_sha256 = "47c6b1caaa11a5a1cf3938a10bf32a21e8723c16ecbb4af8b820874dbe29ba31"
    command "powershell -Command \"if ( $(CertUtil -hashfile pycurl.pyd sha256)[1] -replace \\\" \\\",\\\"\\\" | grep \"#{pycurl_sha256}\" ) { mv pycurl.pyd #{python_lib_path} -force } else { exit 1 } \" "

    command "powershell.exe -Command wget -outfile msvcr110.dll https://s3.amazonaws.com/dd-agent-omnibus/msvcr110.dll"
    vcruntime_sha256 = "0cbbd9691f08434da3617874f99c6dd87538cbd65b5d8bc39fce378d4ed29eed"
    command "powershell -Command \"if ( $(CertUtil -hashfile msvcr110.dll sha256)[1] -replace \\\" \\\",\\\"\\\" | grep \"#{vcruntime_sha256}\" ) { mv msvcr110.dll #{python_lib_path} -force } else { exit 1 } \" "
  end
end
