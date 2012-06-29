require 'mongo'
require 'mongoid'
module Juicy
  def self.dbgp(*args)
    ENV['JUICY_DEBUG'] && $stderr.puts(args)
  end
end

# Load juicy core, followed by extras
["", "controllers", "models"].each do |el|
  Dir[File.dirname(__FILE__) + "/juicy/#{el}/*.rb"].each  do |file|
    Juicy.dbgp "Loading #{file}"
    require file
  end
end
