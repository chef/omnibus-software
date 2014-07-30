require 'bundler/gem_tasks'

task :test do
  OmnibusSoftware.verify!
end

namespace :travis do
  task ci: ['test']
end

task default: ['travis:ci']
