require 'mongo'
require 'mongoid'
module Juicy
  # TODO
  def self.debug
    true
  end

end

def _debug(txt)
  if Juicy.debug
    $stderr.puts txt
  end
end

# Load juicy core, followed by extras
["", "controllers", "models"].each do |el|
  Dir[File.dirname(__FILE__) + "/juicy/#{el}/*.rb"].each  do |file|
    _debug "Loading #{file}"
    require file
  end
end
