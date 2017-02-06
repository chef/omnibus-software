name "datadog-gohai"
default_version "last-stable"

always_build true

env = {
  "GOPATH" => "#{Omnibus::Config.cache_dir}/src/#{name}",
}

if ohai["platform_family"] == "mac_os_x"
  gobin = "/usr/local/bin/go"
elsif ohai["platform"] == "windows"
  gobin = "C:/Go/bin/go"
else
  env["GOROOT"] = "/usr/local/go"
  gobin = "/usr/local/go/bin/go"
end

build do
  ship_license "https://raw.githubusercontent.com/DataDog/gohai/#{version}/LICENSE"
  ship_license "https://raw.githubusercontent.com/DataDog/gohai/#{version}/THIRD_PARTY_LICENSES.md"
  # Go get gohai
  command "#{gobin} get -d -u github.com/DataDog/gohai", :env => env
  # Checkout gohai's deps
  command "#{gobin} get -u github.com/shirou/gopsutil", :env => env
  command "git checkout v2.0.0", :env => env, :cwd => "#{Omnibus::Config.cache_dir}/src/datadog-gohai/src/github.com/shirou/gopsutil"
  command "#{gobin} get -u github.com/cihub/seelog", :env => env
  command "git checkout v2.6", :env => env, :cwd => "#{Omnibus::Config.cache_dir}/src/datadog-gohai/src/github.com/cihub/seelog"
  # Windows depends on the registry, go get that.
  if ohai["platform"] == "windows"
    command "#{gobin} get golang.org/x/sys/windows/registry", :env => env
  end
  # Checkout and build gohai
  command "git checkout #{version} && git pull", :env => env, :cwd => "#{Omnibus::Config.cache_dir}/src/datadog-gohai/src/github.com/DataDog/gohai"
  command "cd #{env['GOPATH']}/src/github.com/DataDog/gohai && #{gobin} run make.go #{gobin} && mv gohai #{install_dir}/bin/gohai", :env => env
end
