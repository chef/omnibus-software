name 'wmi'
default_version '1.4.9'

dependency 'python'
dependency 'pip'

build do
  ship_license 'MIT'
  pip "install -I #{name}==#{version}"
end
