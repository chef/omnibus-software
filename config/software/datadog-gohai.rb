name "datadog-gohai"
default_version "last-stable"

source github: "DataDog/gohai"

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
  # dep manager
  command "#{gobin} get github.com/Masterminds/glide", env: env
  # Checkout and build gohai
  command "#{Omnibus::Config.cache_dir}/src/#{name}/bin/glide install", env: env
  command "#{gobin} run make.go && mv datadog-gohai #{install_dir}/bin/gohai", env: env
end
