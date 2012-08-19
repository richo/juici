module Juicy
  class TriggerController

    attr_reader :project, :params
    def initialize(project, params)
      @project = Project.find_or_create_by(name: project)
      @params = params
    end

    def build!
      environment = BuildEnvironment.new
      Build.new(parent: project.name, command: build_command).tap do |build|
        # The seperation of concerns around this madness is horrifying
        unless environment.load_json!(params['environment'])
          build.warn!("Failed to parse environment")
        end

        build[:environment] = environment.to_hash

        build.save!
        $build_queue << build
      end
    end

    def build_command
      # TODO Throw 422 not acceptable if missing
      params['command'].tap do |c|
        raise "No command given" if c.nil?
      end
    end

  end
end
