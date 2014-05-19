name "datadog-verity"
default_version "last-stable"
source :git => "https://github.com/DataDog/verity.git"

build do
   command "go build -o #{install_dir}/bin/verity"
end
