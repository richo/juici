require 'rake'
require 'rspec/core/rake_task'

require 'juici/database'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "spec/**/*_spec.rb"
end

desc 'Default: run specs'
task :default => :spec

namespace :db do
  desc "Destroy the test db specified in mongoid.yml"
  task :destroy do
    Juici::Database.initialize!
    Mongoid.purge!
  end
end
