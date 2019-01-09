name "jmxfetch"

if windows?
  default_version "0.24.1"
else
  jmx_version = ENV["JMX_VERSION"]
  if jmx_version.nil? || jmx_version.empty?
    raise "Please specify a JMX_VERSION env variable to build."
  else
    default_version jmx_version
  end
end

version "0.24.1" do
  source sha256: "244cdcec15efb9fc9923a868787d3e6a2dad95e169dbee4cb7fe6d122d5109cf"
end

version "0.24.0" do
  source sha256: "819bb28d81de591ce3e89a01302ccdde0f01c5ee782a82c83af18bd7174dc32e"
end

version "0.23.0" do
  source sha256: "b11f914388128791821380603a06ade9c95b3bbe02be40ebaa8e4edae53d7695"
end

jar_dir = "#{install_dir}/agent/checks/libs"
agent_version = ENV["AGENT_VERSION"] || "5"
if agent_version[0] == "6"
  jar_dir = "#{install_dir}/bin/agent/dist/jmx"
end

source :url => "https://dl.bintray.com/datadog/datadog-maven/com/datadoghq/jmxfetch/#{version}/jmxfetch-#{version}-jar-with-dependencies.jar"

relative_path "jmxfetch"

build do
  ship_license "https://raw.githubusercontent.com/DataDog/jmxfetch/master/LICENSE"
  mkdir jar_dir
  copy "jmxfetch-#{version}-jar-with-dependencies.jar", jar_dir
  block { File.chmod(0644, "#{jar_dir}/jmxfetch-#{version}-jar-with-dependencies.jar") }
end
