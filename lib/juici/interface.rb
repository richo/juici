module Juici
end

Dir[File.dirname(__FILE__) + "/interface/*.rb"].each  do |file|
  require file
end
