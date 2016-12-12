name 'py2exe'
default_version '0.6.1'

wheel_name = "py2exe-0.6.10a1-cp27-none-win_amd64.whl"
wheel_md5 = 'ccae3d31fc4c335329cb92f57a5dabf0'

source :url => "https://s3.amazonaws.com/dd-agent-omnibus/#{wheel_name}",
       :md5 => wheel_md5

relative_path "py2exe-#{version}"

dependency "python"
dependency "pip"
dependency "vc_redist"


build do
  pip "install #{wheel_name}"
end
