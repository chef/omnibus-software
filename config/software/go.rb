name "go"
default_version "1.4.2"

if ohai['platform_family'] == 'mac_os_x'
    dependency "homebrew"
	build do
	   command "brew install go"
	end
end
