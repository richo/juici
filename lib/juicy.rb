module Juicy
end

# Dir[File.dirname(__FILE__) + '/juicy/**.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/juicy/**/*.rb'].each  do |file|
  require file
end
