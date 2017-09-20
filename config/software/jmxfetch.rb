name "jmxfetch"

if windows?
  default_version "0.17.0"
else
  jmx_version = ENV["JMX_VERSION"]
  if jmx_version.nil? || jmx_version.empty?
    raise "Please specify a JMX_VERSION env variable to build."
  else
    default_version jmx_version
  end
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

version "0.15.0" do
  source sha256: "fcdcb204203c83409337ef00f34a09092b4314e8ce1ba094595b7c0c153a5678"
end

version "0.16.0" do
  source sha256: "7ca7aee7ba63e5938df35bb6327d7b10c86ed800a88e6c8173a4f5931a25641d"
end

version "0.17.0" do
  source sha256: "e4bea1b045a3770736fbc1bc41cb37ebfd3b628d2180985e363b4b9cd8e77f95"
end

jar_dir = "#{install_dir}/agent/checks/libs"
agent_version = ENV["AGENT_VERSION"] || "5"
if agent_version[0] == "6"
  jar_dir = "#{install_dir}/bin/agent/dist/jmx"
end

source :url => "https://dd-jmxfetch.s3.amazonaws.com/jmxfetch-#{version}-jar-with-dependencies.jar"

relative_path "jmxfetch"

build do
  ship_license "https://raw.githubusercontent.com/DataDog/jmxfetch/master/LICENSE"
  mkdir jar_dir
  copy "jmxfetch-*-jar-with-dependencies.jar", jar_dir
end
