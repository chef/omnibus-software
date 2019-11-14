# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omnibus-software/version"

Gem::Specification.new do |s|
  s.name        = "omnibus-software"
  s.version     = OmnibusSoftware::VERSION
  s.authors     = ["Chef Software, Inc."]
  s.email       = ["info@chef.io"]
  s.homepage    = "https://github.com/chef/omnibus-software"
  s.summary     = %q{Open Source software for use with Omnibus}
  s.description = %q{Open Source software build descriptions for use with Omnibus}

  # Software definitions in this bundle require at least this version of
  # omnibus because of the dsl methods they are using.
  s.add_dependency "omnibus", ">= 5.6.1"

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end
