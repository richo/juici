module Juicy
  class TriggerController

    attr_reader :project, :params
    def initialize(project, params)
      @project = Project.find_or_create_by(name: project)
      @params = params
    end

    def build!
      Build.new(parent: project.name, environment: build_environment,
                  command: build_command).tap do |build|
        build.save!
        $build_queue << build
      end
    end

    def build_environment
      # TODO is inheriting from the parent really a good idea?
      env = ENV.to_hash
      env["RUBYOPT"] = nil
      # TODO Potentially set this to the new one if it exists
      env["BUNDLE_GEMFILE"] = nil

      env.merge(JSON.load(params['environment']))
    end

    def build_command
      # TODO Throw 422 not acceptable if missing
      params['command'].tap do |c|
        raise "No command given" if c.nil?
      end
    end
  end
end
