name "datadog-upgrade-helper"

source github: "DataDog/dd-agent-windows-upgrade-helper"
env = {
  "GOPATH" => "#{Omnibus::Config.cache_dir}/src/#{name}",
}
helper_branch = ENV["UPGRADE_HELPER_BRANCH"]
if helper_branch.nil? || helper_branch.empty?
  default_version "master"
else
  default_version helper_branch
end

build do
  command "go build && move datadog-upgrade-helper.exe #{windows_safe_path(install_dir)}\\bin\\upgrade-helper.exe", env: env
end
