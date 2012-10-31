require 'juici/database'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/test_*.rb']
  t.verbose = true
end

desc 'Default: run specs'
task :default => :test

namespace :db do
  desc "Destroy the test db specified in mongoid.yml"
  task :destroy do
    Juici::Database.initialize!
    Mongoid.purge!
  end
end
