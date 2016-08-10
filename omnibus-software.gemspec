# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omnibus-software/version"

Gem::Specification.new do |s|
  s.name        = "omnibus-software"
  s.version     = OmnibusSoftware::VERSION
  s.authors     = ["Chef Software, Inc."]
  s.email       = ["legal@getchef.com"]
  s.homepage    = "http://github.com/opscode/omnibus-software"
  s.summary     = %q{Open Source software for use with Omnibus}
  s.description = %q{Open Source software build descriptions for use with Omnibus}

  s.rubyforge_project = "omnibus-software"

  # Software definitions in this bundle require at least this version of
  # omnibus because of the dsl methods they are using.
  # FIXME: We need to pin to a later version of omnibus with this PR
  # since we are using a new software DSL: skip_transitive_dependency_licensing
  s.add_dependency "omnibus", ">= 5.2.0"
  s.add_dependency "chef-sugar", ">= 3.4.0"

  s.add_development_dependency "chefstyle", "~> 0.3"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]
end
