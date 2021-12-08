name "jmxterm"

default_version "1.0"

version "1.0" do
  source md5: "f7fcba346072f88632bb7db798a21dd2"
end

source url: "https://dd-jmxfetch.s3.amazonaws.com/jmxterm-#{version}-DATADOG-uber.jar"

relative_path "jmxterm"

build do
  license "BSD-3-Clause"
  license_file "https://raw.githubusercontent.com/DataDog/jmxfetch/master/LICENSE"
  mkdir "#{install_dir}/agent/checks/libs"
  copy "jmxterm-*-DATADOG-uber.jar", "#{install_dir}/agent/checks/libs"
end
