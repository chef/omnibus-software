name 'py2exe'
default_version '0.6.1'

#TODO: react according to the platform
# if ohai['kernel']['machine'] == 'x86_64'
#   wheel_name = "py2exe-0.6.10a1-cp27-none-win_amd64.whl"
#   wheel_md5 = 'ccae3d31fc4c335329cb92f57a5dabf0'
# else
wheel_name = "py2exe-0.6.10a1-cp27-none-win32.whl"
wheel_md5 = 'b7d27c59447afe8bdb1eb945a1a24f2e'
# end
source :url => "https://s3.amazonaws.com/dd-agent-omnibus/#{wheel_name}",
       :md5 => wheel_md5

dependency "python"
dependency "pip"
dependency "vc_redist"

build do
    relative_path "py2exe-#{version}"
    # FIXME: It shouldn't really be here but... we're just running pip you know
    pip "install #{wheel_name}"
end
