require 'bundler/gem_tasks'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

task :test do
  OmnibusSoftware.verify!
end

namespace :travis do
  task ci: ['rubocop', 'test']
end

task default: ['travis:ci']
