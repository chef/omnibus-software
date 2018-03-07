require "bundler/gem_tasks"
require "omnibus-software"

task :test do
  OmnibusSoftware.verify!
end

task :fetch do
  rake_fakeout
  software_name = ARGV[1]
  path = ARGV[2] || "."
  puts "Downloading #{software_name} to #{path}"
  OmnibusSoftware.fetch(software_name, path)
end

task :fetch_all do
  rake_fakeout
  path = ARGV[1] || "."
  puts "Downloading all software to #{path}"
  OmnibusSoftware.fetch_all(path)
end

def rake_fakeout
  ARGV.each { |a| task a.to_sym {} } # rubocop: disable Lint/AmbiguousBlockAssociation
end

task :list do
  OmnibusSoftware.list
end

require "json"
require "chefstyle"
require "rubocop/rake_task"
desc " Run ChefStyle"
RuboCop::RakeTask.new(:chefstyle) do |task|
  task.options << "--display-cop-names"
end

namespace :travis do
  task ci: %w{chefstyle test}
end

task default: ["travis:ci"]
