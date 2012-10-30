ENV['RACK_ENV'] ||= "test"

require 'juici'
require "test/unit"
require 'mocha'

require 'fileutils'

Dir["#{File.expand_path(File.dirname(__FILE__))}/helpers/**/*.rb"].each do |f|
  puts "Requiring #{f}"
  require f
end

def assert_false(other)
  assert_equal(other, false)
end

def assert_true(other)
  assert_equal(other, true)
end
