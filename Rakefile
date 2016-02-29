require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'omnibus-software'

RuboCop::RakeTask.new

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
  ARGV.each { |a| task a.to_sym {} }
end

task :list do
  OmnibusSoftware.list
end

namespace :travis do
  task ci: ['rubocop', 'test']
end

task default: ['travis:ci']
