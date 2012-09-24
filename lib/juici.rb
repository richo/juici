require 'mongo'
require 'mongoid'
module Juici
  def self.dbgp(*args)
    ENV['JUICY_DEBUG'] && $stderr.puts(args)
  end
end

# Load juici core, followed by extras
["", "controllers", "models"].each do |el|
  Dir[File.dirname(__FILE__) + "/juici/#{el}/*.rb"].each  do |file|
    Juici.dbgp "Loading #{file}"
    require file
  end
end
