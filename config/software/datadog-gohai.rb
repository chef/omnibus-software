name "datadog-gohai"
default_version "last-stable"

env = {
  "GOROOT" => "/usr/local/go",
  "GOPATH" => "/var/cache/omnibus/src/datadog-gohai"
}

if ohai['platform_family'] == 'mac_os_x'
  env.delete "GOROOT"
  gobin = "/usr/local/bin/go"
else
  gobin = "/usr/local/go/bin/go"
end

build do
   ship_license "https://raw.githubusercontent.com/DataDog/gohai/#{version}/LICENSE"
   ship_license "https://raw.githubusercontent.com/DataDog/gohai/#{version}/THIRD_PARTY_LICENSES.md"
   # Go get gohai
   command "#{gobin} get -d -u github.com/DataDog/gohai", :env => env
   # Checkout gohai's deps
   command "#{gobin} get -u github.com/shirou/gopsutil", :env => env
   command "git checkout v2.0.0", :env => env, :cwd => "/var/cache/omnibus/src/datadog-gohai/src/github.com/shirou/gopsutil"
   # Checkout and build gohai
   command "git checkout #{version} && git pull", :env => env, :cwd => "/var/cache/omnibus/src/datadog-gohai/src/github.com/DataDog/gohai"
   command "cd $GOPATH/src/github.com/DataDog/gohai && #{gobin} run make.go '#{gobin}' && mv gohai #{install_dir}/bin/gohai", :env => env
end
