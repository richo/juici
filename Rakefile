require 'rake'
require 'rspec/core/rake_task'

require 'juici/database'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "spec/**/*_spec.rb"
end

desc 'Default: run specs'
task :default => :spec

desc "Build all gems"
task :gems do
  %w[juici juici-interface].each do |gem|
    `gem build #{gem}.gemspec`
  end
end

desc "Delete all built gems"
task :clean do
  Dir["juici-*.gem"].each do |gem|
    File.unlink(gem)
  end
end
