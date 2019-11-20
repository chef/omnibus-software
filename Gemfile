source "https://rubygems.org"
gemspec

group :development, :test do
  gem "omnibus", git: "https://github.com/chef/omnibus", branch: "jm/deep_sign"
  gem "highline"
  gem "rake"
  gem "chefstyle"
end

if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.5")
  gem "ohai", "<15"
end
