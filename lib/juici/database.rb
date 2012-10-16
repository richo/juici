require 'mongoid'
module Juici
  class Database
    class << self
      def mongoid_config_file
        %w[mongoid.yml mongoid.yml.sample].each do |file|
          path = File.join("config", file)
          return path if File.exist?(path)
        end
        raise "No database config file"
      end

      def initialize!
        ::Juici.dbgp "initializing Mongoid with environment: #{ENV['RACK_ENV']}"
        if ENV['RACK_ENV'] == "development"
          Mongoid.logger.level = Logger::INFO
        end

        Mongoid.load!(mongoid_config_file)
      end
    end
  end
end
