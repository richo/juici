require 'mongo'
require 'mongoid'
module Juicy
end

# Load juicy core, followed by extras
["", "controllers", "models"].each do |el|
  Dir[File.dirname(__FILE__) + "/juicy/#{el}/*.rb"].each  do |file|
    puts "Loading #{file}"
    require file
  end
end
