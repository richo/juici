module Juici
  BUILD_SENSITIVE_VARIABLES = %w[RUBYOPT BUNDLE_GEMFILE RACK_ENV MONGOLAB_URI GEM_PATH WORKING_DIR GEM_HOME]
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
      return true if json == ""
      loaded_json = JSON.load(json)
      if loaded_json.is_a? Hash
        env.merge!(loaded_json)
        return true
      end
      false
    rescue JSON::ParserError
      return false
    end

    def load_hash!(hash)
      env.merge!(hash)
    end

    def to_hash
      env.reject { |key, value| value.nil? }
    end

    def to_environment
      env
    end

  end
end
