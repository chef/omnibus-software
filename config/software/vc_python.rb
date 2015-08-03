# Microsoft Visual C++ for Python

name 'vc_python'
default_version '2.7'

source :url => 'https://s3.amazonaws.com/dd-agent-omnibus/vc_for_python_27.msi',
       :md5 => '4e6342923a8153a94d44ff7307fcdd1f'

build do
    command "start /wait msiexec /x vc_for_python_27.msi /qn"
    command "start /wait msiexec /i vc_for_python_27.msi /qn"
    # TODO : ship that, pycrypto probably needs it !!!
    touch "#{install_dir}/uselessfile"
end

