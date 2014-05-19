name "datadog-verity"
default_version "last-stable"
source :git => "https://github.com/DataDog/verity.git"
always_build true
build do

   command "mkdir -p #{install_dir}/bin/"
   command "go build -o #{install_dir}/bin/verity"
end
