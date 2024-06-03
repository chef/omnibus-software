$:.push File.expand_path("lib", __dir__)
require "omnibus-software/version"

Gem::Specification.new do |s|
  s.name        = "omnibus-software"
  s.version     = OmnibusSoftware::VERSION
  s.authors     = ["Chef Software, Inc."]
  s.email       = ["info@chef.io"]
  s.license     = "Apache-2.0"
  s.homepage    = "https://github.com/chef/omnibus-software"
  s.summary     = "Open Source software for use with Omnibus"
  s.description = "Open Source software build descriptions for use with Omnibus"

  # Software definitions in this bundle require at least this version of
  # omnibus because of the dsl methods they are using.
  s.add_dependency "omnibus", ">= 9.0.0"
  s.add_dependency "ffi", "< 1.17.0" # 1.17 requires ruby 3.3

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end
