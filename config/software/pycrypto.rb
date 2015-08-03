name "pycrypto"
default_version "2.6.1"

dependency "python"
dependency "pip"

if ohai['platform'] == 'windows'
  dependency 'vc_python'
end

build do
  pip_call "install #{name}==#{version}"
end
