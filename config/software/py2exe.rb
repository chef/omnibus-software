name "py2exe"
default_version "0.6.1"

wheel_name = "py2exe-0.6.10a1-cp27-none-win_amd64.whl"
wheel_sha256 = "9bd80b9fa81f8f39db24efcefe405d87aaf7dcb1a321c11d228e6713ae02b208"

source url: "https://s3.amazonaws.com/dd-agent-omnibus/#{wheel_name}",
       sha256: wheel_sha256

relative_path "py2exe-#{version}"

dependency "python"
dependency "pip"
dependency "vc_redist"

build do
  pip "install #{wheel_name}"
end
