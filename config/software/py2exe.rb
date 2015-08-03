name 'py2exe'
default_version '0.6.1'

#TODO: react according to the platform
source :url => "http://www.lfd.uci.edu/~gohlke/pythonlibs/3i673h27/py2exe-#{version}0a1-cp27-none-win_amd64.whl",
       :md5 => 'ccae3d31fc4c335329cb92f57a5dabf0'

dependency "python"
dependency "pip"
dependency "vc_redist"

build do
    relative_path "py2exe-#{version}"
    # FIXME: It shouldn't really be here but... we're just running pip you know
    pip_call "install py2exe-#{version}0a1-cp27-none-win_amd64.whl"
end
