name "jmxfetch"

jmx_version = ENV["JMX_VERSION"]
if jmx_version.nil? || jmx_version.empty?
  default_version "0.14.0"
else
  default_version jmx_version
end

version "0.12.0" do
  source md5: "2a04e4f02de90b7bbd94e581afb73c8f"
end

version "0.13.0" do
  source sha256: "741a74e8aed6bcfd726399bf0e5094bb622f7a046004a57e3e39e11f53f72aa0"
end

version "0.13.1" do
  source sha256: "7dcd8370c500b68e53465e6cc4b578302919cd272c12d2a32b4766eb41c03339"
end

version "0.14.0" do
  source sha256: "e4fa8ce43f2af3e6ee9ddbcdb7c34a84646484374c8e19718ce507fdee96ec55"
end

source :url => "https://dd-jmxfetch.s3.amazonaws.com/jmxfetch-#{version}-jar-with-dependencies.jar"

relative_path "jmxfetch"

build do
  ship_license "https://raw.githubusercontent.com/DataDog/jmxfetch/master/LICENSE"
  mkdir "#{install_dir}/agent/checks/libs"
  copy "jmxfetch-*-jar-with-dependencies.jar", "#{install_dir}/agent/checks/libs"
end
