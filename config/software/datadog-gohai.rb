name "datadog-gohai"
default_version "last-stable"
always_build true

go_path "/var/cache/omnibus/src/datadog-gohai"

env = {
  "GOROOT" => "/usr/local/go",
  "GOPATH" => go_path
}

build do
   command "$GOROOT/bin/go get -d -u github.com/DataDog/gohai", :env => env
   command "git checkout #{default_version} && git pull", :env => env, :cwd => "#{go_path}/src/github.com/DataDog/gohai"
   command "$GOROOT/bin/go build -o #{install_dir}/bin/gohai $GOPATH/src/github.com/DataDog/gohai/gohai.go", :env => env
end
