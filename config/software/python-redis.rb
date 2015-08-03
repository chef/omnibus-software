name "python-redis"
default_version "2.10.3"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/andymccurdy/redis-py/master/LICENSE"
  if ohai['platform'] == 'windows'
    pip_call "install --install-option=\"--install-scripts='"\
             "#{windows_safe_path(install_dir)}\\bin\" redis==#{version}"
  else
    pip_call "install --install-option=\"--install-scripts=#{install_dir}/bin\" "\
             "redis==#{version}"
  end
end
