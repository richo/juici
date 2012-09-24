ENV['RACK_ENV'] ||= "development"
Mongoid.logger.level = Logger::INFO
Mongoid.load!("config/mongoid.yml")
