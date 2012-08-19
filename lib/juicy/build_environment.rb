module Juicy
  BUILD_SENSITIVE_VARIABLES = %w[RUBYOPT BUNDLE_GEMFILE RACK_ENV MONGOLAB_URI]
  class BuildEnvironment

    attr_reader :env
    def initialize
      @env = ENV.to_hash.tap do |env|
        BUILD_SENSITIVE_VARIABLES.each do |var|
          env[var] = nil
        end
        env["BUNDLE_CONFIG"] = "/nonexistent"
      end
    end

    def [](k)
      env[k]
    end

    # XXX This is spectacular.
    # Not in the good way
    def load_json!(json)
      loaded_json = JSON.load(json)
      if loaded_json.is_a? Hash
        env.merge!(loaded_json)
        return true
      end
      false
    rescue JSON::ParserError
      return false
    end

    def to_hash
      env
    end

  end
end
