ENV['RACK_ENV'] ||= "test"

require 'juici'
require 'mocha'

require 'fileutils'
require 'timeout'

module Juici::Helpers
  Dir[File.expand_path("../../lib/juici/helpers/**/*.rb", __FILE__)].each do |f|
    load f
  end
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
