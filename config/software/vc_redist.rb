# Microsoft Visual C++ redistributable

name 'vc_redist'
default_version '90'

# TODO: same for 32 bits
source :url => 'https://s3.amazonaws.com/dd-agent-omnibus/msvcrntm_x64.tar.xz',
       :md5 => 'c400e8d66b2e723df1a05759bec3cde8'

relative_path "vc_redist"

build do
    # We also need to have these dlls side by side with the `.exe`... I think
    command "XCOPY /YEH .\\*.dll \"#{windows_safe_path(install_dir)}\\embedded\" /MIR"
end
