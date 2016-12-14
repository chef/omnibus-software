name 'py2app'

default_version '0.9.0'
dependency 'pip'

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}

build do
  pip "install -U py2app", :env => env
end
