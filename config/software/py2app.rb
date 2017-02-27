name "py2app"

default_version "0.10.0"
dependency "pip"

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}",
}

build do
  pip "install py2app==#{version}", env: env
end
