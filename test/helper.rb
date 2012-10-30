ENV['RACK_ENV'] ||= "test"

require 'juici'
require "test/unit"

require 'fileutils'

Dir["#{File.expand_path(File.dirname(__FILE__))}/helpers/**/*.rb"].each do |f|
  puts "Requiring #{f}"
  require f
end
