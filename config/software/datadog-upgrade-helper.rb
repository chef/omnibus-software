name "datadog-upgrade-helper"
default_version "last-stable"

env = {
  "GOPATH" => "#{Omnibus::Config.cache_dir}/src/#{name}",
}

if ohai["platform"] == "windows"
  gobin = "C:/Go/bin/go"
end

build do
  # Go get the upgrade helper
  command "#{gobin} get -d -u github.com/DataDog/dd-agent-windows-upgrade-helper", :env => env
  # Checkout and build the helper
  command "git checkout #{version} && git pull", :env => env, :cwd => "#{Omnibus::Config.cache_dir}/src/datadog-upgrade-helper/src/github.com/DataDog/dd-agent-windows-upgrade-helper"
  command "cd #{env['GOPATH']}/src/github.com/DataDog/dd-agent-windows-upgrade-helper && #{gobin} build && mv dd-agent-windows-upgrade-helper #{install_dir}/bin/upgrade-helper", :env => env
end