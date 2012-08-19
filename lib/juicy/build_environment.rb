module Juicy
  class BuildEnvironment

    attr_reader :env
    def initialize
      @env = ENV.to_hash.tap do |env|
        %w[RUBYOPT BUNDLE_GEMFILE RACK_ENV MONGOLAB_URI].each do |var|
          env[var] = nil
        end
        env["BUNDLE_CONFIG"] = "/nonexistent"
      end
    end

    def [](k)
      env[k]
    end

    def load_json!(json)
      begin
        env.merge!(JSON.load(json)) unless json.nil? || json.empty?
      rescue JSON::ParserError
        return false
      end
      return true
    end

    def to_hash
      env
    end

  end
end
