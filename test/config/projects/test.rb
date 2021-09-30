name "test"
maintainer "Chef Software, Inc."
homepage "https://www.chef.io"

install_dir "#{default_root}/#{name}"

build_version   Omnibus::BuildVersion.semver
build_iteration 1

dependency ENV["SOFTWARE"]

if ENV["VERSION"]
  override ENV["SOFTWARE"].to_sym, version: ENV["VERSION"]
end