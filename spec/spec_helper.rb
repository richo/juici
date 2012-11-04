ENV['RACK_ENV'] ||= "test"

require 'juici'
require 'mocha'

require 'fileutils'
require 'timeout'

Dir["#{File.expand_path(File.dirname(__FILE__))}/helpers/**/*.rb"].each do |f|
  puts "Requiring #{f}"
  require f
end

RSpec.configure do |config|
  config.mock_framework = :mocha
end

def poll_build(build)
  loop do
    sleep(0.1)
    build.reload
    break if build.status != Juici::BuildStatus::START
  end
end

Juici::Database.initialize!
