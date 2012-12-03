require 'github/markdown'
require 'ansible'

ENV['RACK_ENV'] ||= "development"

module Juici
  def self.dbgp(*args)
    if ENV['JUICI_DEBUG'] || env == "development"
      $stderr.puts(args)
    end
  end

  def self.env
    ENV['JUICI_ENV'] || ENV['RACK_ENV']
  end
end

# Load juici core, followed by extras
%w[
  app
  build_environment
  build_logic
  build_queue
  callback
  config
  controllers
  database
  exceptions
  find_logic
  interface
  routes
  server
  version
  watcher
].each do |file|
  require File.expand_path("../juici/#{file}", __FILE__)
end
%w[controllers models].each do |el|
  Dir[File.dirname(__FILE__) + "/juici/#{el}/*.rb"].each  do |file|
    Juici.dbgp "Loading #{file}"
    require file
  end
end
