# Microsoft Visual C++ redistributable

name 'vc_redist'
default_version '90'

# TODO: same for 32 bits
# source :url => 'https://s3.amazonaws.com/dd-agent-omnibus/msvcrntm_x64.tar.gz',
source :url => 'http://degemer.github.io/msvcrntm_x64.tar.gz',
       :sha256 => '8473bb0c6a1c83e12e2392317f7e9197694833d4eb2c27621859396c868faeda',
       :extract => :seven_zip

relative_path "vc_redist"

build do
    # We also need to have these dlls side by side with the `.exe`... I think
    command "XCOPY /YEH .\\*.dll \"#{windows_safe_path(install_dir)}\\embedded\" /MIR"
end
