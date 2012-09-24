module Juici
  class TriggerController

    attr_reader :project, :params
    def initialize(project, params)
      @project = Project.find_or_create_by(name: project)
      @params = params
    end

    def build!
      environment = BuildEnvironment.new
      Build.new(parent: project.name).tap do |build|
        # The seperation of concerns around this madness is horrifying
        unless environment.load_json!(params['environment'])
          build.warn!("Failed to parse environment")
        end

        build[:command] = build_command
        build[:priority] = build_priority
        build[:environment] = environment.to_hash

        build.save!
        $build_queue << build
      end
    end

    # These accessors are not really the concern of a "Controller". On the
    # other hand, this thing is also not a controller realistically, so I'm
    # just going to carry on using this as a mechanism to poke at my model.
    #
    # I later plan to implement a more strictly bounded interface which bails
    # instead of coercing.
    def build_command
      # TODO Throw 422 not acceptable if missing
      params['command'].tap do |c|
        raise "No command given" if c.nil?
      end
    end

    def build_priority
      if params['priority'] =~ /^[0-9]+$/
        params['priority'].to_i
      else
        1
      end
    end

  end
end
