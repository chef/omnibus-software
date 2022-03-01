name "psutil"
default_version "5.5.0"

dependency "python"
dependency "pip"

build do
  license "BSD-3-CLause"
  license_file "https://raw.githubusercontent.com/giampaolo/psutil/#{version}/LICENSE"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
