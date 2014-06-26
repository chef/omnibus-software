name "datadog-gohai"
default_version "last-stable"
always_build true

env = {
  "GOROOT" => "/usr/local/go",
  "GOPATH" => "/var/cache/omnibus/src/datadog-gohai"
}

build do
   command "$GOROOT/bin/go get -d -u github.com/DataDog/gohai", :env => env
   command "cd $GOPATH/src/github.com/DataDog/gohai/ && git checkout #{default_version} %% git pull", :env => env
   command "$GOROOT/bin/go build -o #{install_dir}/bin/gohai $GOPATH/src/github.com/DataDog/gohai/gohai.go", :env => env
end
