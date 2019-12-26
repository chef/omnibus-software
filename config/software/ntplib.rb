name "ntplib"
default_version "0.3.3"

dependency "python"
dependency "pip"

build do
  ship_license "MIT"
  if ohai["platform"] == "windows"
    pip "install "\
        "--install-option=\"--install-scripts='#{windows_safe_path(install_dir)}\\bin'\" "\
        "#{name}==#{version}"
  else
    pip "install "\
        "--install-option=\"--install-scripts=#{install_dir}/bin\" "\
        "#{name}==#{version}", cwd: "/tmp"
  end
end
