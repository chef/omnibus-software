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

task :test_build do
  rake_fakeout
  software = ARGV[1]
  version = ARGV[2] || "default"

  raise "\nERROR: You must specify a software name\n\n" if software.nil?

  command = "docker-compose run --rm -e CI=true -e SOFTWARE=#{software}"
  command += " -e VERSION=#{version}" unless version == "default"
  command += " builder"

  sh command
end

def rake_fakeout
  ARGV.each { |a| task a.to_sym {} } # rubocop: disable Lint/AmbiguousBlockAssociation
end

task :list do
  OmnibusSoftware.list
end

desc "Check Linting and code style."
task :style do
  require "rubocop/rake_task"
  require "cookstyle/chefstyle"

  if RbConfig::CONFIG["host_os"] =~ /mswin|mingw|cygwin/
    # Windows-specific command, rubocop erroneously reports the CRLF in each file which is removed when your PR is uploaeded to GitHub.
    # This is a workaround to ignore the CRLF from the files before running cookstyle.
    sh "cookstyle --chefstyle -c .rubocop.yml --except Layout/EndOfLine"
  else
    sh "cookstyle --chefstyle -c .rubocop.yml"
  end
rescue LoadError
  puts "Rubocop or Cookstyle gems are not installed. bundle install first to make sure all dependencies are installed."
end

task default: %w{style test}
