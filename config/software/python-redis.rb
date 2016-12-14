name "python-redis"
default_version "2.10.3"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/andymccurdy/redis-py/master/LICENSE"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "redis==#{version}"
end
