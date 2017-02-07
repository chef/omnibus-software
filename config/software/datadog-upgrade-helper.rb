name "datadog-upgrade-helper"
default_version "master"
source github: "DataDog/dd-agent-windows-upgrade-helper"
env = {
  "GOPATH" => "#{Omnibus::Config.cache_dir}/src/#{name}",
}

if ohai["platform"] == "windows"
  gobin = "C:/Go/bin/go"
end

build do
  command "#{gobin} build && mv datadog-upgrade-helper #{install_dir}/bin/upgrade-helper", :env => env
end
