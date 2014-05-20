name "datadog-verity"
default_version "last-stable"

build do
   command "go get github.com/DataDog/verity"
   command "cd $GOPATH/src/github.com/DataDog/verity"
   command "go build -o #{install_dir}/bin/verity"
end
