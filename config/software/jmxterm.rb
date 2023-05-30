name "jmxterm"

default_version "1.0"

version "1.0" do
  source sha256: "bc8de7f529ccafa42d566dc5348c0783e2995bc6aa56d8eb6c8a4ef17a776558"
end

source url: "https://dd-jmxfetch.s3.amazonaws.com/jmxterm-#{version}-DATADOG-uber.jar"

relative_path "jmxterm"

build do
  license "BSD-3-Clause"
  license_file "https://raw.githubusercontent.com/DataDog/jmxfetch/master/LICENSE"
  mkdir "#{install_dir}/agent/checks/libs"
  copy "jmxterm-*-DATADOG-uber.jar", "#{install_dir}/agent/checks/libs"
end
