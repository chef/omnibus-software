name "datadog-verity"
default_version "last-stable"

env = {
  "GOROOT" => "/usr/local/go",
  "GOPATH" => "/var/cache/omnibus/src/datadog-verity"
}

build do
   command "$GOROOT/bin/go get -d -u github.com/DataDog/verity", :env => env
   command "cd $GOPATH/src/github.com/DataDog/verity", :env => env
   command "$GOROOT/bin/go build -o #{install_dir}/bin/verity", :env => env
end
